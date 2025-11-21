# Deploying a Single Server

This Terraform configuration deploys a single EC2 instance in AWS.

## Prerequisites

1. **Terraform installed** - Make sure Terraform is installed on your system
2. **AWS Account** - You need an AWS account with appropriate permissions
3. **AWS Credentials** - Configure your AWS credentials using one of the methods below

## Configuring AWS Credentials

You need to configure AWS credentials before running Terraform. Choose one of the following methods:

### Option 1: Environment Variables (Recommended for testing)

Set the following environment variables in your terminal:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
```

To get your AWS access keys:
1. Log in to the AWS Console
2. Go to IAM → Users → Your User → Security credentials
3. Click "Create access key"
4. Copy the Access Key ID and Secret Access Key

### Option 2: AWS Credentials File

Create or edit `~/.aws/credentials`:

```ini
[default]
aws_access_key_id = your-access-key-id
aws_secret_access_key = your-secret-access-key
```

### Option 3: AWS CLI Configuration

If you have AWS CLI installed, you can configure it:

```bash
aws configure
```

This will prompt you for:
- AWS Access Key ID
- AWS Secret Access Key
- Default region (e.g., `us-east-2`)
- Default output format (e.g., `json`)

### Multiple AWS Profiles

If you have multiple AWS profiles configured (e.g., `default` and SSO profiles), you can specify which profile to use in your Terraform configuration:

```hcl
provider "aws" {
  region  = "us-east-2"
  profile = "default"  # or specify your profile name
}
```

**Note:** SSO credentials expire after a period of time. If you're using an SSO profile, make sure your credentials are refreshed. You can verify a profile's credentials with:

```bash
aws sts get-caller-identity --profile <profile-name>
```

## Usage

1. **Initialize Terraform:**
   ```bash
   terraform init
   ```

2. **Review the plan:**
   ```bash
   terraform plan
   ```

3. **Apply the configuration:**
   ```bash
   terraform apply
   ```

4. **Destroy resources when done:**
   ```bash
   terraform destroy
   ```

## Troubleshooting

### Error: "The security token included in the request is invalid"

This error means your AWS credentials are not configured correctly. Common causes:

1. **Multiple profiles with expired credentials**: If you have multiple AWS profiles (e.g., `default` and SSO profiles), Terraform might be trying to use an expired profile. Solution: Explicitly specify the profile in your `provider` block:
   ```hcl
   provider "aws" {
     region  = "us-east-2"
     profile = "default"  # Use the profile with valid credentials
   }
   ```

2. **Expired SSO credentials**: SSO session tokens expire. Refresh them using your SSO login process.

3. **Invalid credentials**: Make sure:
   - Your AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables are set (if using Option 1)
   - Your `~/.aws/credentials` file exists and has valid credentials (if using Option 2)
   - Your AWS CLI is configured correctly (if using Option 3)
   - Your credentials have the necessary permissions to create EC2 instances

### Error: "The specified instance type is not eligible for Free Tier"

This error occurs when:
- Your AWS account's 12-month Free Tier period has expired
- You've already used up your Free Tier allocation for that instance type
- The instance type is not Free Tier eligible in your region

**Solutions:**

1. **Use a Free Tier eligible instance type**: The configuration uses `t3.micro` which is Free Tier eligible. Other options include:
   - `t3.micro` (x86)
   - `t4g.micro` (ARM/Graviton2)
   - `t3.small` (x86)
   - `t4g.small` (ARM/Graviton2)

2. **Check Free Tier eligible instance types**:
   ```bash
   aws ec2 describe-instance-types \
     --filters "Name=free-tier-eligible,Values=true" \
     --query "InstanceTypes[*].InstanceType" \
     --output table
   ```

3. **Use a non-Free Tier instance type**: If you're okay with incurring charges, you can use any instance type. Just be aware of the costs.

4. **Note about AMI compatibility**: If switching to ARM-based instances (t4g.*), make sure your AMI supports ARM architecture.

### Verify Your Credentials

You can verify your AWS credentials are working by running:

```bash
aws sts get-caller-identity
```

This should return your AWS account ID, user ARN, and user ID if credentials are configured correctly.

