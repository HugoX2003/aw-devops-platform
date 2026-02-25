pipeline {
  agent any

  environment {
    AWS_REGION   = "us-east-1"
    CLUSTER_NAME = "dev-challenge-hugo"
  }

  stages {
    stage('Checkout') {
      steps { checkout scm }
    }

    stage('Verify tools') {
      steps {
        sh '''
          set -e
          aws --version
          kubectl version --client=true
        '''
      }
    }

    stage('Configure kubeconfig') {
      steps {
        withCredentials([
          string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            set -e
            export AWS_DEFAULT_REGION="${AWS_REGION}"
            export KUBECONFIG="$WORKSPACE/kubeconfig"

            aws eks update-kubeconfig --name "${CLUSTER_NAME}" --region "${AWS_REGION}" --kubeconfig "$KUBECONFIG"
            kubectl get nodes -o wide
          '''
        }
      }
    }

    stage('Apply Deployment') {
      steps {
        withCredentials([
          string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            set -e
            export KUBECONFIG="$WORKSPACE/kubeconfig"

            kubectl apply -f k8s/day-10/nginx-deployment.yaml
            kubectl get pods -l app=nginx -o wide
            kubectl get deployment nginx-deployment
          '''
        }
      }
    }

    stage('Apply Service (LoadBalancer) + wait EXTERNAL') {
      steps {
        withCredentials([
          string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            set -e
            export KUBECONFIG="$WORKSPACE/kubeconfig"

            kubectl apply -f k8s/day-10/nginx-service.yaml

            # Esperar a que EXTERNAL-IP deje de ser <pending> y aparezca hostname/IP
            for i in $(seq 1 60); do
              EXT=$(kubectl get svc nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)
              if [ -n "$EXT" ]; then
                echo "EXTERNAL HOSTNAME: $EXT"
                break
              fi
              echo "Esperando LB... ($i/60)"
              sleep 10
            done

            kubectl get svc nginx-service -o wide
            kubectl describe svc nginx-service
          '''
        }
      }
    }

    stage('Test external access (curl)') {
      steps {
        withCredentials([
          string(credentialsId: 'aws_access_key_id', variable: 'AWS_ACCESS_KEY_ID'),
          string(credentialsId: 'aws_secret_access_key', variable: 'AWS_SECRET_ACCESS_KEY')
        ]) {
          sh '''
            set -e
            export KUBECONFIG="$WORKSPACE/kubeconfig"

            EXT=$(kubectl get svc nginx-service -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
            echo "Probando http://$EXT"
            curl -sS "http://$EXT" | head
          '''
        }
      }
    }
  }
}