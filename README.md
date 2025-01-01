teraform으로 프로비저닝하는 단계를 크게 4가지로 구분함. 동시에 모든 것을 했을 때 인증 문제가 발생하는게 가장 큰 요인이고, 코드가 길어지다 보니 사소한 변경이 있을 때 전체를 모두 돌릴 때 시간이 걸리는 이슈도 한 몫함.

01-landing-zone
빌링 계정과 Org ID만 발급 받은 상태에서 거버넌스 및 컴플라이언스에 필요한 프로젝트들과 베이스라인을 설정해줌. 
테라폼 상태 정보를 원격에서 관리하기 위해 GCS bucket이 필요함. GCK bucket을 가지고 테라폼을 수행할 Host project는 별도로 생성한 후 테라폼을 실행해야 함
backend.tf에 테라폼 상태 정보를 저장하는 GCS Bucket을 적어두고, 변수 값에 Org ID와 빌링 계정 정보를 입력한 후 테라폼 프로비저닝.
기존 폴더 구조는 아래와 같이 만들어짐
<img width="326" alt="Screenshot 2025-01-01 at 11 23 12 AM" src="https://github.com/user-attachments/assets/4d64ffb6-e453-4156-a02b-e96dd900c4be" />
Common 폴더에는 central logging monitoring 프로젝트와 논프로덕션용 Shared vpc 프로젝트, production용 shared 프로젝트가 생성됨. 
각 

이후부터는 project별로 워크스페이스를 구분하여 사용함
워크스페이스 생성
```bash
terraform workspace new <project_name>
```
워크스페이스 목록 확인
```bash
terraform workspace list
```
워크스페이스 선택
```bash
terraform workspace select <project_name>
```
워크스페이스별로 다른 변수 값을 사용하려면 terraform.tfvars 파일을 워크스페이스 이름으로 구분하여 생성합니다. (예: dev.tfvars, staging.tfvars, prod.tfvars)
또는, TF_WORKSPACE 환경 변수를 사용하여 조건부 변수 할당을 할 수 있습니다.
예시 (dev.tfvars, prod.tfvars):

# dev.tfvars
project_id = "my-dev-project"
region     = "us-central1"
# prod.tfvars
project_id = "my-prod-project"
region     = "us-east1"
예시 (main.tf에서 TF_WORKSPACE 사용):

Terraform

# main.tf

locals {
  env = terraform.workspace
}

resource "google_storage_bucket" "bucket" {
  name = "my-bucket-${local.env}" # 워크스페이스 이름에 따라 다른 버킷 이름 사용
}
6. 워크스페이스별 백엔드 구성 (권장):

각 워크스페이스의 상태 파일을 서로 다른 위치에 저장하려면, 백엔드 구성을 워크스페이스별로 다르게 설정해야 합니다.
terraform init 시 -backend-config 옵션을 사용하거나, terraform 블록 내에서 조건부 백엔드 구성을 사용할 수 있습니다.
예시 (terraform 블록 내 조건부 백엔드 구성):

Terraform

# main.tf

terraform {
  backend "gcs" {
    bucket = "my-tfstate-bucket"                  # 상태 파일을 저장할 버킷
    prefix = "terraform/state/${terraform.workspace}" # 워크스페이스별로 상태 파일 경로 구분
  }
}
7. 워크스페이스 삭제:

terraform workspace delete 명령어를 사용하여 워크스페이스를 삭제합니다.

Bash

terraform workspace delete <workspace_name>
주의: 워크스페이스를 삭제하기 전에, 해당 워크스페이스에 속한 리소스를 모두 삭제해야 합니다.

워크스페이스 사용 예시:

워크스페이스 생성:

Bash

terraform workspace new dev
terraform workspace new prod
dev 워크스페이스 선택:

Bash

terraform workspace select dev
dev.tfvars 파일 생성 및 변수 값 설정:

# dev.tfvars
project_id = "my-dev-project"
region     = "us-central1"
terraform apply 실행:

Bash

terraform apply -var-file="dev.tfvars"
prod 워크스페이스 선택:

Bash

terraform workspace select prod
prod.tfvars 파일 생성 및 변수 값 설정:

# prod.tfvars
project_id = "my-prod-project"
region     = "us-east1"
terraform apply 실행:

Bash

terraform apply -var-file="prod.tfvars"
추가 팁:

terraform.workspace 변수를 사용하여 현재 선택된 워크스페이스 이름을 참조할 수 있습니다.
terraform workspace show 명령어를 사용하여 현재 선택된 워크스페이스 이름을 확인할 수 있습니다.
워크스페이스를 사용하면 동일한 Terraform 구성을 사용하여 여러 환경을 쉽게 관리할 수 있습니다.
워크스페이스별로 다른 백엔드 구성을 사용하면 상태 파일을 안전하게 분리하여 관리할 수 있습니다.

02-service
