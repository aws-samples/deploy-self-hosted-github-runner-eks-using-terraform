githubConfigUrl: ${githubConfigUrl}
minRunners: ${minRunners}
maxRunners: ${maxRunners}
runnerGroup: "default"
# name of the runner scale set to create.  Defaults to the helm release name
runnerScaleSetName: ${node-pool-name}
template:
  spec:
    nodeSelector:
      node-pool: ${node-pool-name}
    tolerations:
      - key: "node-pool"
        operator: "Equal"
        value: "${node-pool-name}"
        effect: "NoSchedule"
    containers:
      - name: runner
        image: ghcr.io/actions/actions-runner:latest
        command: ["/home/runner/run.sh"]
        resources:
          requests:
            cpu: ${cpu}
            memory: ${memory}