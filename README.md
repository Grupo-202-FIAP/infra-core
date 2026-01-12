# Infraestrutura AWS - nexTime-food

Infraestrutura de rede AWS para a plataforma nexTime-food, implementada com Terraform. Fornece uma arquitetura multi-tier segura com VPC, subnets públicas e privadas, gateways, grupos de segurança e endpoints de VPC.

## Sumário

- [Visão Geral](#visão-geral)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Início Rápido](#início-rápido)
- [Estrutura de Diretórios](#estrutura-de-diretórios)
- [Variáveis de Configuração](#variáveis-de-configuração)
- [Outputs](#outputs)
- [Considerações de Segurança](#considerações-de-segurança)
- [Custos Estimados](#custos-estimados)
- [Documentação de Módulos](#documentação-de-módulos)

## Visão Geral

Este projeto provê a infraestrutura de rede completa para a plataforma nexTime-food na AWS, incluindo:

- **VPC** (10.0.0.0/16) com suporte a múltiplas zonas de disponibilidade
- **Subnets públicas e privadas** para isolamento de recursos
- **Internet Gateway** e **NAT Gateway** para acesso à internet
- **Bastion Host** (EC2) para acesso SSH seguro
- **Grupos de Segurança** para controle granular de tráfego
- **VPC Endpoints** para acesso privado a serviços AWS
- **Network ACL** para proteção adicional na camada de rede
- **RDS Subnet Group** para banco de dados PostgreSQL

**Região**: us-east-1  
**Proprietário**: nexTime-food

## Arquitetura

```
┌─────────────────────────────────────────────────────────────────┐
│                           VPC (10.0.0.0/16)                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │                    us-east-1a / us-east-1b              │   │
│  │                                                          │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │          Public Subnets (10.0.1.0/24)          │   │   │
│  │  │      (10.0.2.0/24)                             │   │   │
│  │  │                                                 │   │   │
│  │  │  ┌──────────────────┐  ┌──────────────────┐   │   │   │
│  │  │  │  Bastion Host    │  │   API Server     │   │   │   │
│  │  │  │    (EC2 t3)      │  │  (Application)   │   │   │   │
│  │  │  └──────────────────┘  └──────────────────┘   │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  │                        ↓ IGW                            │   │
│  │                                                          │   │
│  │  ┌─────────────────────────────────────────────────┐   │   │
│  │  │        Private Subnets (10.0.6.0/24)           │   │   │
│  │  │      (10.0.10.0/24)                            │   │   │
│  │  │                                                 │   │   │
│  │  │  ┌──────────────────┐  ┌──────────────────┐   │   │   │
│  │  │  │    RDS/Database  │  │   Lambda         │   │   │   │
│  │  │  │   (PostgreSQL)   │  │  (VPC Endpoint)  │   │   │   │
│  │  │  └──────────────────┘  └──────────────────┘   │   │   │
│  │  └─────────────────────────────────────────────────┘   │   │
│  │                        ↑ NAT GW                         │   │
│  │                                                          │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
└─────────────────────────────────────────────────────────────────┘
```

### Componentes Principais

| Componente | CIDR/Tipo | Zona | Propósito |
|-----------|-----------|------|----------|
| VPC | 10.0.0.0/16 | us-east-1 | Rede privada isolada |
| Public Subnet 1 | 10.0.1.0/24 | us-east-1a | Bastion e API tier |
| Public Subnet 2 | 10.0.2.0/24 | us-east-1b | Bastion e API tier |
| Private Subnet 1 | 10.0.6.0/24 | us-east-1a | Banco de dados |
| Private Subnet 2 | 10.0.10.0/24 | us-east-1b | Banco de dados |
| Internet Gateway | - | us-east-1 | Acesso à internet para subnets públicas |
| NAT Gateway | - | us-east-1 | Acesso à internet para subnets privadas |

## Pré-requisitos

### Ferramentas Necessárias
- **Terraform** >= 1.0.0 ([Download](https://www.terraform.io/downloads))
- **AWS CLI** >= 2.0 ([Instalação](https://aws.amazon.com/pt/cli/))
- **Git** (para clonar o repositório)

### Credenciais AWS
Você precisa ter as credenciais AWS configuradas. Existem várias formas:

```bash
# Opção 1: Variáveis de ambiente
export AWS_ACCESS_KEY_ID="sua-chave-de-acesso"
export AWS_SECRET_ACCESS_KEY="sua-chave-secreta"
export AWS_DEFAULT_REGION="us-east-1"

# Opção 2: Arquivo ~/.aws/credentials
aws configure

# Opção 3: Assumir um papel IAM
aws sts assume-role --role-arn arn:aws:iam::123456789012:role/role-name
```

### Chave SSH
- Você precisa de uma chave SSH chamada `ssh_arch` criada na AWS em us-east-1
- Esta chave é usada para acessar o Bastion Host
- Para criar: `aws ec2 create-key-pair --key-name ssh_arch --region us-east-1`

### Bucket S3 para State
- Um bucket S3 chamado `nextime-food-state-bucket` deve existir
- Este bucket armazena o arquivo `terraform.tfstate`

## Início Rápido

### 1. Clone o Repositório
```bash
git clone <seu-repositorio>
cd infra-core
```

### 2. Inicialize o Terraform
```bash
cd infra
terraform init
```

Este comando:
- Cria a estrutura `.terraform/`
- Baixa os provedores (AWS)
- Configura o backend remoto (S3)

### 3. Validar Configuração
```bash
terraform validate
```

Verifica se a sintaxe está correta.

### 4. Visualizar Plano de Execução
```bash
terraform plan -out=tfplan
```

Este comando mostra exatamente quais recursos serão criados, modificados ou destruídos. **Sempre revise este output antes de aplicar!**

### 5. Aplicar Configuração
```bash
terraform apply tfplan
```

Cria todos os recursos na AWS. Você verá o progresso e um resumo dos recursos criados.

### 6. Obter Outputs
```bash
terraform output
```

Exibe informações importantes sobre os recursos criados (IPs, IDs, etc).

## Estrutura de Diretórios

```
infra-core/
├── README.md                          # Documentação principal
├── terraform.tfstate                  # State file local
├── script-ssh.md                      # Instruções de SSH
│
├── infra/                             # Configuração principal
│   ├── main.tf                        # Orquestração de módulos
│   ├── variables.tf                   # Variáveis de entrada
│   ├── outputs.tf                     # Outputs da infraestrutura
│   ├── providers.tf                   # Configuração do provider AWS
│   ├── terraform.tfvars               # Valores das variáveis
│   ├── tfplan                         # Plano de execução salvo
│   │
│   ├── bootstrap/                     # Inicialização de recursos
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   │
│   └── modules/                       # Módulos reutilizáveis
│       ├── vpc/                       # VPC (Virtual Private Cloud)
│       ├── subnet/                    # Subnets públicas e privadas
│       ├── internet_gateway/          # Internet Gateway
│       ├── nat_gateway/               # NAT Gateway
│       ├── route_table/               # Route Table pública
│       ├── route_table_private/       # Route Table privada
│       ├── security_group/            # Grupos de Segurança
│       │   ├── bastion_sg/            # SG para Bastion
│       │   ├── public_sg/             # SG para API
│       │   ├── private_sg/            # SG para Banco de dados
│       │   └── lambda_sg/             # SG para Lambda
│       ├── acl/                       # Network ACL
│       ├── ec2_bastion/               # Instância EC2 Bastion
│       ├── vpc_endpoint/              # VPC Endpoints
│       └── rds/                       # RDS (Relational Database Service)
```

### Descrição dos Módulos

- **vpc**: Cria a VPC principal com CIDR configurável
- **subnet**: Gerencia subnets públicas e privadas em múltiplas AZs
- **internet_gateway**: Conecta a VPC à internet
- **nat_gateway**: Permite outbound internet de subnets privadas
- **route_table**: Define rotas para subnets públicas (via IGW)
- **route_table_private**: Define rotas para subnets privadas (via NAT GW)
- **security_group**: Implementa firewalls em nível de aplicação (4 variantes)
- **acl**: Define Network ACLs para proteção adicional
- **ec2_bastion**: Provisiona Bastion Host para acesso SSH
- **vpc_endpoint**: Cria endpoints para acessar serviços AWS sem sair da VPC
- **rds**: Cria subnet group para RDS (banco de dados)

## Variáveis de Configuração

As variáveis são definidas em `infra/terraform.tfvars`. Principais valores:

```hcl
aws_region          = "us-east-1"
owner               = "nexTime-food"
vpc_cidr            = "10.0.0.0/16"
public_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets     = ["10.0.6.0/24", "10.0.10.0/24"]
availability_zones  = ["us-east-1a", "us-east-1b"]

# Bastion
bastion_instance_type = "t3.micro"
bastion_key_name      = "ssh_arch"
bastion_ssh_cidr      = "0.0.0.0/0"  # ⚠️ Ver Segurança

# RDS
db_engine = "postgres"
db_name   = "nexfood"
```

Para modificar valores, edite `infra/terraform.tfvars`.

## Outputs

Após `terraform apply`, os seguintes valores são exportados:

| Output | Descrição | Uso Típico |
|--------|-----------|-----------|
| `vpc_id` | ID da VPC | Referência em outras stacks |
| `public_subnet_ids` | IDs das subnets públicas | Deploy de Bastion/API |
| `private_subnet_ids` | IDs das subnets privadas | Deploy de RDS/Lambda |
| `internet_gateway_id` | ID do Internet Gateway | Referência em rotas |
| `nat_gateway_id` | ID do NAT Gateway | Referência em rotas privadas |
| `bastion_sg_id` | ID do SG do Bastion | Referência em rules |
| `api_sg_id` | ID do SG da API | Referência em rules |
| `postgres_sg_id` | ID do SG do Postgres | Referência em rules |
| `lambda_sg_id` | ID do SG do Lambda | Referência em rules |
| `bastion_public_ip` | IP público do Bastion | Acesso SSH |
| `acl_id` | ID da Network ACL | Gerenciamento de ACL |

Visualize os outputs com:
```bash
terraform output
terraform output vpc_id
```

## Considerações de Segurança

### ⚠️ Alertas de Segurança

1. **SSH CIDR Aberto**: Atualmente `bastion_ssh_cidr = "0.0.0.0/0"`
   - **Risco**: Qualquer IP pode tentar acessar o Bastion
   - **Recomendação**: Altere para seu IP público ou CIDR da sua rede
   - **Exemplo**: `bastion_ssh_cidr = "203.0.113.0/32"`  (seu IP)

2. **Bucket S3 Sem Encriptação**: O state file contém informações sensíveis
   - **Recomendação**: Ativar SSE-S3 e versionamento no bucket

3. **Rds Sem Backup**: Banco de dados não configurado com backup automático
   - **Recomendação**: Ativar backup retention e Multi-AZ

### Boas Práticas Implementadas

✓ Grupos de segurança separados por tier (público/privado/banco)  
✓ Subnets privadas sem acesso direto à internet  
✓ NAT Gateway para outbound apenas  
✓ Network ACL para proteção adicional  
✓ VPC Endpoints para acesso a serviços AWS sem sair da VPC  
✓ Tags em todos os recursos para identificação  

### Recomendações Adicionais

1. **Habilitar VPC Flow Logs**: Para auditar tráfego de rede
2. **Usar AWS KMS**: Para encriptar dados em repouso
3. **Configurar CloudTrail**: Para auditoria de ações na AWS
4. **MFA no AWS**: Para proteger credenciais root
5. **Usar Roles IAM**: Em vez de access keys

## Custos Estimados

Custo mensal aproximado em us-east-1 (valores em USD):

| Recurso | Tipo | Quantidade | Custo Unitário | Total |
|---------|------|-----------|----------------|-------|
| VPC | Fixo | 1 | 0.00 | $0.00 |
| Subnets | Fixo | 4 | 0.00 | $0.00 |
| Internet Gateway | Fixo | 1 | 0.00 | $0.00 |
| NAT Gateway | Horário | 1 | $32.00/mês | $32.00 |
| Transferência de dados | GB | ~1 TB | $0.02/GB | $20.00 |
| EC2 Bastion (t3.micro) | Horário | 1 | ~$8.00/mês | $8.00 |
| Elastic IP | Fixo | 1 | $3.65/mês | $3.65 |
| **Total Estimado** | | | | **~$63.65/mês** |

> **Nota**: Este é um cálculo estimado. Custos reais podem variar conforme uso. Consulte [AWS Pricing Calculator](https://calculator.aws/#/) para cálculos mais precisos.

**Dicas para Reduzir Custos**:
- Usar VPC Endpoints ao invés de NAT Gateway (economiza $32/mês)
- Parar instâncias EC2 quando não em uso
- Usar Reserved Instances para workloads previsíveis
- Revisar regularly com CloudWatch

## Troubleshooting

### Erro: "Access Denied" no S3
```bash
# Verifique permissões no bucket
aws s3 ls s3://nextime-food-state-bucket/

# Verifique credenciais AWS
aws sts get-caller-identity
```

### Erro: "Key Pair not found"
```bash
# Verifique se a chave SSH existe
aws ec2 describe-key-pairs --region us-east-1 --query 'KeyPairs[*].KeyName'

# Crie se não existir
aws ec2 create-key-pair --key-name ssh_arch --region us-east-1 --query 'KeyMaterial' > ssh_arch.pem
chmod 600 ssh_arch.pem
```

### Erro: "Quota Exceeded"
Você atingiu um limite de recursos na AWS. Contate suporte ou ajuste limites em Service Quotas.

### Erro: "Invalid CIDR"
Verifique formato dos CIDRs em `terraform.tfvars`. Deve ser `x.x.x.x/yy`.

## Próximos Passos

1. **Deploy RDS**: Configure variáveis de banco em `terraform.tfvars`
2. **Deploy ECS/EKS**: Para aplicações containerizadas
3. **Setup CI/CD**: Integre Terraform com GitHub Actions
4. **Monitoring**: Configure CloudWatch e alertas
5. **Disaster Recovery**: Configure backups e replicação

## Contribuindo

Para fazer alterações:

1. Crie uma branch: `git checkout -b feature/sua-feature`
2. Faça as mudanças
3. Valide: `terraform validate && terraform fmt`
4. Crie um PR para revisão
5. Após aprovação, faça merge e deploy

## Documentação de Módulos

### Módulo: modules/acl

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) | resource |
| [aws_network_acl_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl_name"></a> [acl\_name](#input\_acl\_name) | Nome do ACL | `string` | n/a | yes |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | ID da subnet associada | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags aplicadas ao ACL | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID da VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acl_id"></a> [acl\_id](#output\_acl\_id) | n/a |

---

### Módulo: modules/internet_gateway

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_igw_name"></a> [igw\_name](#input\_igw\_name) | Nome do IGW | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags aplicadas ao IGW | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID da VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | n/a |

---

### Módulo: modules/route_table

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gateway_id"></a> [gateway\_id](#input\_gateway\_id) | ID do Internet Gateway | `string` | n/a | yes |
| <a name="input_route_cidr"></a> [route\_cidr](#input\_route\_cidr) | CIDR para rota padr├úo | `string` | `"0.0.0.0/0"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Lista de IDs das subnets | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags aplicadas ├á route table | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID da VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | n/a |

---

### Módulo: modules/subnet

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |

## Inputs

| Name | Description                   | Type | Default | Required |
|------|-------------------------------|------|---------|:--------:|
| <a name="input_azs"></a> [azs](#input\_azs) | Zonas de disponibilidade      | `list(string)` | n/a | yes |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | CIDRs das subnets privadas    | `list(string)` | n/a | yes |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | CIDRs das subnets públicas    | `list(string)` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Prefixo para nome das subnets | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags aplicadas ás subnets     | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID da VPC                     | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | n/a |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | n/a |

---

### Módulo: modules/vpc

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | CIDR da VPC | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags aplicadas ├á VPC | `map(string)` | `{}` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Nome da VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |

---

### Módulo: modules/security_group/private_sg

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.postgres](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_sg_id"></a> [api\_sg\_id](#input\_api\_sg\_id) | ID do SG da API que pode acessar o banco | `string` | n/a | yes |
| <a name="input_sg_postgres_name"></a> [sg\_postgres\_name](#input\_sg\_postgres\_name) | Nome do SG do PostgreSQL | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags aplicadas ao SG | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID da VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postgres_sg_id"></a> [postgres\_sg\_id](#output\_postgres\_sg\_id) | n/a |

---

### Módulo: modules/security_group/public_sg

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_security_group.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_sg_api_name"></a> [sg\_api\_name](#input\_sg\_api\_name) | Nome do SG da API | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags aplicadas ao SG | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ID da VPC | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | n/a |

---

