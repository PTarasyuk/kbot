pipeline {
    agent any
    
    environment {
        REPO = 'https://github.com/ptarasyuk/kbot'
        BRANCH = 'main'
    }

    parametrs {
        choice(name: 'arch', choices: ['amd64', 'arm64'], description: 'Target architecture')
        choice(name: 'os', choices: ['linux', 'darwin', 'windows'], description: 'Target OS')
    }

    stages {
        
        stage("clone") {
            steps {
                echo 'CLONE REPOSITORY'
                git branch: "${BRANCH}", url: "${REPO}"
            }
        }
        
        stage("test") {
            steps {
                echo 'TEST EXECUTION STARTED'
                sh 'make test'
            }
        }
        
        stage("build") {
            steps {
                echo 'BUILD EXECUTION STARTED'
                sh "make build TARGETARCH=$params.arch TARGETOS=$params.os"
            }
        }
        
        stage("image") {
            steps {
                script {
                    echo 'IMAGE EXECUTION STARTED'
                    sh "make image TARGETARCH=$params.arch"
                }
            }
        }
        
        stage("push") {
            steps {
                script {
                    echo 'PUSH EXECUTION STARTED'
                    docker.withRegistry( '', 'dockerhub' ) {
                        sh "make push TARGETARCH=$params.arch"
                    }
                }
            }
        }
    }
}
