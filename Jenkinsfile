pipeline {
  agent any

  environment {
    AWS_REGION = "us-east-1"
    CLUSTER_NAME = "dev-challenge-hugo"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Verify tools') {
      steps {
        sh '''
          set -e
          aws --version
          kubectl version --client=true
          eksctl version
        '''
      }
    }

    stage('Create EKS cluster (eksctl)') {
      steps {
        withCredentials([
          string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            set -e
            export AWS_DEFAULT_REGION="${AWS_REGION}"

            eksctl create cluster \
              --name "${CLUSTER_NAME}" \
              --region "${AWS_REGION}" \
              --node-type t3.small \
              --nodes 2
          '''
        }
      }
    }

    stage('Configure kubeconfig + verify nodes') {
      steps {
        withCredentials([
          string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            set -e
            export AWS_DEFAULT_REGION="${AWS_REGION}"

            aws eks --region "${AWS_REGION}" update-kubeconfig --name "${CLUSTER_NAME}"
            kubectl get nodes -o wide
          '''
        }
      }
    }

    stage('Smoke test (nginx pod)') {
      steps {
        sh '''
          set -e
          kubectl run test-nginx --image=nginx --restart=Never --port 80
          kubectl get pods -o wide
          kubectl delete pod test-nginx
        '''
      }
    }
  }
}