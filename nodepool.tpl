apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: ${node-pool-name}
spec:
  template:
    metadata:
      # Labels are arbitrary key-values that are applied to all nodes
      labels:
        node-pool: ${node-pool-name}
      # Annotations are arbitrary key-values that are applied to all nodes
    spec:
      requirements:
        - key: node.kubernetes.io/instance-type
          operator: In
          values: [${instance_type}]
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["on-demand"]
      taints:
        - key: node-pool
          value: ${node-pool-name}
          effect: NoSchedule
      nodeClassRef:
        name: default

  disruption:
    consolidationPolicy: WhenEmpty
    consolidateAfter: 30s

  limits:
    cpu: "170"
    memory: 650Gi