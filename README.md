'''
# Terraform AWS EC2 – Strapi Deployment

## Objective
Deploy a Strapi application on an AWS EC2 instance using Terraform with automated setup via `user_data`. Demonstrates Infrastructure as Code and basic AWS concepts.

---

## Prerequisites

- Terraform >= 1.0.0  
- AWS CLI configured with valid credentials  
- AWS account with EC2 and Security Group permissions  
- Existing AWS Key Pair (`strapi-key.pem`)  

---

## Quick Start
1. Navigate & Initialize
- cd terraform-strapi-ec2
- terraform init
2. Preview & Deploy
- terraform plan      # Shows 3 resources to add
- terraform apply     # Type "yes"
3. Access Strapi
- Public IP:  terraform output public_ip
- Strapi:     http://YOUR_IP:1337
- Admin:      http://YOUR_IP:1337/admin

**SSH Access**
ssh -i strapi-key.pem ubuntu@YOUR_IP
Node v12 fix (if needed):

curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs
npx create-strapi-app@latest myapp --quickstart
npm run develop &
## Terraform Commands
Command	Purpose
- terraform init	  --> Setup providers
- terraform plan	--> Preview changes
- terraform apply	--> Deploy
- terraform output	--> Show IPs
- terraform destroy	--> Cleanup
  
📊 Resources Created
✓ EC2 t3.micro (Free Tier)
✓ Security Group (22/80/1337)
✓ Node.js v20.20.0 auto-install
✓ Strapi v5 ready 
'''
