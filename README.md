# Stellar Archivist
Docker image to run Stellar Archivist in cloud environment (GKE & Co)
## Usage example
### Kubernates' Job (GKE)
#### Mirroring an archive
```
$ stellar-archivist mirror http://s3-eu-west-1.amazonaws.com/history.stellar.org/prd/core-testnet/core_testnet_001 file://out
```
is equal to the following Kubernetes Job manifest:
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: archivist-job
spec:
  backoffLimit: 1
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: archivist
        image: "otokarev/stellar-archivist:v0.2.0"
        args:
        - "mirror"
        - "http://s3-eu-west-1.amazonaws.com/history.stellar.org/prd/core-testnet/core_testnet_001"
        - "file://out"
        volumeMounts:
        - name: "disk-3"
          mountPath: "/out"
      volumes:
      - name: "disk-3"
        gcePersistentDisk:
          pdName: "disk-3"
          fsType: "ext4"
```
