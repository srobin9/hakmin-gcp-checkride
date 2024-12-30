# modules/jenkins-helm/values.tpl

# 예시: values.yaml 파일의 controller.adminUser, controller.adminPassword 값을 템플릿 변수로 설정
controller:
  adminUser: ${admin_user}
  adminPassword: ${admin_password}