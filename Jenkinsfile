pipeline {
    agent any
    environment {
        AWS_REGION      = "eu-central-1"  // Set your AWS region
        ECR_REPOSITORY  = "cicd-infra"      // ECR repository name
        IMAGE_NAME      = "cicd-test-app"   // Your Docker image name
        IMAGE_TAG       = "${env.BUILD_NUMBER}"  // Using Jenkins BUILD_NUMBER for versioning
        AWS_ACCOUNT_ID  = "225320283044"    // Your AWS account ID
        ECR_URL         = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
    }
    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from GitHub
                git credentialsId: 'github-org-credentials', url: 'https://github.com/Opsmiths-Technologies/cicd-infra.git', branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
                // Build the Docker image and tag it using the ECR URL, repository, image name and tag
                sh "docker build -t $ECR_URL/$ECR_REPOSITORY:$IMAGE_TAG ."
            }
        }
        stage('Login to ECR') {
            steps {
                // Use the withAWS step to configure AWS CLI credentials for this block
                withAWS(credentials: 'aws-credentials', region: "${AWS_REGION}") {
                    sh "aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL"
                }
            }
        }
        stage('Push to ECR') {
            steps {
                // Push the image to ECR
                sh "docker push $ECR_URL/$ECR_REPOSITORY:$IMAGE_TAG"
            }
        }
        stage('Trigger Ansible Deployment') {
            steps {
                // Use withAWS here as well (if needed in the playbook) and trigger the Ansible playbook with the dynamic image name
                withAWS(credentials: 'aws-credentials', region: "${AWS_REGION}") {
                    sh """
                    ansible-playbook -i /etc/ansible/inventory.ini /etc/ansible/deploy.yml \
                    --extra-vars "image=$ECR_URL/$ECR_REPOSITORY:$IMAGE_TAG app_name=$IMAGE_NAME aws_region=$AWS_REGION"
                    """
                }
            }
        }
    }
}
