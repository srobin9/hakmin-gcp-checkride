teraform으로 프로비저닝하는 단계를 크게 4가지로 구분함. 동시에 모든 것을 했을 때 인증 문제가 발생하는게 가장 큰 요인이고, 코드가 길어지다 보니 사소한 변경이 있을 때 전체를 모두 돌릴 때 시간이 걸리는 이슈도 한 몫함.

01-landing-zone
빌링 계정과 Org ID만 발급 받은 상태에서 거버넌스 및 컴플라이언스에 필요한 프로젝트들과 베이스라인을 설정해줌. 
테라폼 상태 정보를 원격에서 관리하기 위해 GCS bucket이 필요함. GCK bucket을 가지고 테라폼을 수행할 Host project는 별도로 생성한 후 테라폼을 실행해야 함
backend.tf에 테라폼 상태 정보를 저장하는 GCS Bucket을 적어두고, 변수 값에 Org ID와 빌링 계정 정보를 입력한 후 테라폼 프로비저닝.

<img width="326" alt="Screenshot 2025-01-01 at 11 23 12 AM" src="https://github.com/user-attachments/assets/4d64ffb6-e453-4156-a02b-e96dd900c4be" />
