KUBECOST_ADDRESS=http://a7285fb6fa6604cfc844eeb0450d3edf-925257942.ap-northeast-2.elb.amazonaws.com:9090

curl -G \
  -d 'targetCPUUtilization=0.8' \
  -d 'targetRAMUtilization=0.8' \
  -d 'window=3d' \
  ${KUBECOST_ADDRESS}/model/savings/requestSizing
