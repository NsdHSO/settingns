# Fix Strapi Transfer Issue - NFS Volume Restructure Plan

## Context

The `yarn strapi transfer` command is failing with the error:
```
The backup folder for the assets could not be created inside the public folder.
Please ensure Strapi has write permissions on the public directory
```

**Root Cause:** Strapi's transfer process attempts to rename the `/opt/app/public/uploads` directory as a backup (e.g., `uploads` → `uploads_backup_<timestamp>`). When `uploads` is mounted as a volume mount point, the rename operation fails with an EBUSY error (resource busy/locked). This is a known issue in containerized Strapi deployments (GitHub issues #17809, #22953).

**Solution:** Mount the NFS volume at the parent directory `/opt/app/public` instead of `/opt/app/public/uploads`. This makes `uploads` a regular directory (not a mount point) that can be renamed during the backup process.

**Requirement:** The NFS volume data must be restructured so files are in an `uploads/` subdirectory, with `robots.txt` at the root level.

---

## Critical Files

### Files to Modify:
- `/Users/davidsamuel.nechifor/Work/financial_health/financial-health/k8s-financial-health/base/strapi/strapi-deployment.yml` (line 64)
  - Change: `mountPath: /opt/app/public/uploads` → `mountPath: /opt/app/public`

### Files to Create:
- `/Users/davidsamuel.nechifor/Work/financial_health/financial-health/k8s-financial-health/base/strapi/migration-pod.yaml`
  - Temporary pod for safe NFS data restructuring

### Reference Files:
- `/Users/davidsamuel.nechifor/Work/financial_health/strapi/strapi/public/robots.txt` (source for robots.txt content)
- `/Users/davidsamuel.nechifor/Work/financial_health/financial-health/k8s-financial-health/base/strapi/strapi-nfs-pvc.yml` (PVC configuration reference)

---

## Implementation Steps

### Phase 1: Pre-Migration Backup

1. **Verify current state and create backups:**
   ```bash
   # Set namespace
   oc project bcr-financial-health-test

   # Backup current deployment config
   oc get deployment strapi -o yaml > /tmp/strapi-deployment-backup.yaml

   # List current NFS files for verification
   oc exec deployment/strapi -- ls -la /opt/app/public/uploads/ > /tmp/nfs-file-list.txt

   # Count files
   oc exec deployment/strapi -- find /opt/app/public/uploads/ -type f | wc -l
   ```

### Phase 2: Scale Down Strapi

2. **Prevent concurrent access during migration:**
   ```bash
   # Scale to 0 replicas
   oc scale deployment strapi --replicas=0

   # Wait for pod termination
   oc wait --for=delete pod -l app=strapi --timeout=120s
   ```

### Phase 3: Deploy Migration Pod

3. **Create migration pod YAML:**

   File: `/Users/davidsamuel.nechifor/Work/financial_health/financial-health/k8s-financial-health/base/strapi/migration-pod.yaml`

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
     name: strapi-nfs-migration
     labels:
       app: strapi-migration
   spec:
     restartPolicy: Never
     containers:
       - name: migration
         image: busybox:1.36
         command: ["/bin/sh"]
         args: ["-c", "echo 'Migration pod ready' && sleep 3600"]
         volumeMounts:
           - mountPath: /mnt/nfs-root
             name: nfs-volume
     volumes:
       - name: nfs-volume
         persistentVolumeClaim:
           claimName: strapi-uploads-nfs-pvc
   ```

4. **Apply and wait for migration pod:**
   ```bash
   oc apply -f k8s-financial-health/base/strapi/migration-pod.yaml
   oc wait --for=condition=Ready pod/strapi-nfs-migration --timeout=120s
   ```

### Phase 4: Restructure NFS Data

5. **Verify current NFS structure:**
   ```bash
   # Check what's in NFS root
   oc exec strapi-nfs-migration -- ls -la /mnt/nfs-root/

   # Count files
   oc exec strapi-nfs-migration -- find /mnt/nfs-root/ -type f | wc -l
   ```

6. **Create uploads directory and move files:**
   ```bash
   # Create uploads subdirectory
   oc exec strapi-nfs-migration -- mkdir -p /mnt/nfs-root/uploads

   # Move all files except robots.txt to uploads/
   oc exec strapi-nfs-migration -- sh -c '
     cd /mnt/nfs-root
     for item in *; do
       if [ "$item" != "uploads" ] && [ "$item" != "robots.txt" ]; then
         echo "Moving: $item"
         mv "$item" uploads/
       fi
     done
   '

   # Move hidden files (if any)
   oc exec strapi-nfs-migration -- sh -c '
     cd /mnt/nfs-root
     for item in .*; do
       if [ "$item" != "." ] && [ "$item" != ".." ]; then
         mv "$item" uploads/
       fi
     done
   '
   ```

7. **Ensure robots.txt exists at root:**
   ```bash
   # Check if robots.txt exists
   oc exec strapi-nfs-migration -- ls -la /mnt/nfs-root/robots.txt

   # If missing, create it
   oc exec strapi-nfs-migration -- sh -c 'cat > /mnt/nfs-root/robots.txt <<EOF
   # To prevent search engines from seeing the site altogether, uncomment the next two lines:
   # User-Agent: *
   # Disallow: /
   EOF'
   ```

8. **Verify migration:**
   ```bash
   # Check root structure (should only have uploads/ and robots.txt)
   oc exec strapi-nfs-migration -- ls -la /mnt/nfs-root/

   # Check uploads/ has files
   oc exec strapi-nfs-migration -- ls -la /mnt/nfs-root/uploads/ | head -20

   # Verify file count matches
   oc exec strapi-nfs-migration -- find /mnt/nfs-root/uploads/ -type f | wc -l
   ```

### Phase 5: Update Kubernetes Configuration

9. **Update deployment YAML:**

   In file: `/Users/davidsamuel.nechifor/Work/financial_health/financial-health/k8s-financial-health/base/strapi/strapi-deployment.yml`

   Change line 64:
   ```yaml
   # FROM:
   - mountPath: /opt/app/public/uploads
     name: strapi-uploads

   # TO:
   - mountPath: /opt/app/public
     name: strapi-uploads
   ```

10. **Apply updated configuration:**
    ```bash
    cd /Users/davidsamuel.nechifor/Work/financial_health/financial-health/k8s-financial-health

    # Verify kustomize build
    oc kustomize overlays/test | grep -A 5 "volumeMounts:" | grep "mountPath.*public"

    # Apply changes
    oc apply -k overlays/test
    ```

### Phase 6: Cleanup and Restart

11. **Remove migration pod:**
    ```bash
    oc delete pod strapi-nfs-migration
    ```

12. **Scale up Strapi:**
    ```bash
    # Scale back to 1 replica
    oc scale deployment strapi --replicas=1

    # Wait for pod to be ready
    oc wait --for=condition=Ready pod -l app=strapi --timeout=300s
    ```

---

## Verification Steps

### Verify Strapi Startup

1. **Check pod logs:**
   ```bash
   oc logs -l app=strapi --tail=50
   ```
   - ✅ Should NOT see "upload folder doesn't exist" error
   - ✅ Should see normal Strapi startup messages

2. **Verify mount structure:**
   ```bash
   # Check mount point
   oc exec deployment/strapi -- df -h | grep public

   # Verify directory structure
   oc exec deployment/strapi -- ls -la /opt/app/public/
   # Expected: uploads/, robots.txt

   oc exec deployment/strapi -- ls -la /opt/app/public/uploads/ | head -10
   # Expected: uploaded files
   ```

### Verify Transfer Functionality

3. **Test transfer command:**
   ```bash
   # From local machine, run transfer
   cd /Users/davidsamuel.nechifor/Work/financial_health/strapi/strapi

   yarn strapi transfer --to=https://strapi-bcr-financial-health-test.apps.ostst.bcr.os/admin
   ```
   - ✅ Should NOT see "backup folder could not be created" error
   - ✅ Should successfully create backup directory and transfer data

4. **Verify backup folder creation:**
   ```bash
   # Check for backup folder (created during transfer)
   oc exec deployment/strapi -- ls -la /opt/app/public/
   # Should see uploads_backup_<timestamp> or similar
   ```

### Verify Application Health

5. **Test HTTP endpoints:**
   ```bash
   # Test main route
   curl -I https://strapi-bcr-financial-health-test.apps.ostst.bcr.os/

   # Test robots.txt
   curl https://strapi-bcr-financial-health-test.apps.ostst.bcr.os/robots.txt
   ```

6. **Test admin panel:**
   - Login to Strapi admin
   - Upload a test file
   - Verify file is accessible via URL
   - Check Media Library shows all existing files

---

## Rollback Procedure

If issues occur, follow these steps to restore original state:

```bash
# 1. Scale down Strapi
oc scale deployment strapi --replicas=0

# 2. Recreate migration pod
oc apply -f k8s-financial-health/base/strapi/migration-pod.yaml
oc wait --for=condition=Ready pod/strapi-nfs-migration --timeout=120s

# 3. Move files back to root
oc exec strapi-nfs-migration -- sh -c '
  cd /mnt/nfs-root/uploads
  for item in * .*; do
    if [ "$item" != "." ] && [ "$item" != ".." ]; then
      mv "$item" ../
    fi
  done
'

# 4. Remove uploads directory
oc exec strapi-nfs-migration -- rmdir /mnt/nfs-root/uploads

# 5. Restore original deployment
oc apply -f /tmp/strapi-deployment-backup.yaml

# 6. Delete migration pod
oc delete pod strapi-nfs-migration

# 7. Scale up
oc scale deployment strapi --replicas=1
```

---

## Success Criteria

- [x] Strapi pod starts without errors
- [x] Mount point is `/opt/app/public` (not `/opt/app/public/uploads`)
- [x] Files accessible at `/opt/app/public/uploads/` inside pod
- [x] `robots.txt` accessible at `/robots.txt` route
- [x] `yarn strapi transfer` command completes successfully
- [x] No EBUSY or "backup folder" errors
- [x] Existing uploaded files remain accessible
- [x] Can upload new files via admin panel

---

## Safety Notes

- **No data loss:** Using `mv` command (atomic on same filesystem)
- **Downtime window:** Pod scaled to 0 during migration (prevents concurrent access)
- **Backups created:** Deployment YAML and file list backed up before changes
- **Verification steps:** Multiple checkpoints to confirm data integrity
- **Rollback ready:** Clear procedure to restore original state if needed

---

## Timeline

- Phase 1-2 (Backup & Scale Down): 5-10 minutes
- Phase 3-4 (Migration Pod & Data Restructure): 10-20 minutes
- Phase 5-6 (Config Update & Restart): 10-15 minutes
- Verification: 10 minutes

**Total: ~35-55 minutes**
