apiVersion: karpenter.k8s.aws/v1beta1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiFamily: AL2 # Amazon Linux 2
  role: "${role_name}"
  tags:
    Name: "${cluster_name}-node-karpenter"
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: 30Gi
        volumeType: gp2
        deleteOnTermination: true
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: "${cluster_name}"

  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery: "${cluster_name}"
