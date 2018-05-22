#!/usr/bin/env groovy
String cron_string = BRANCH_NAME == "master" ? "H H(0-8) * * *" : ""

pipeline {
  agent { label 'master' }
  triggers { cron(cron_string) }

  environment {
    SLACK_COLOR_DANGER  = '#E01563'
    SLACK_COLOR_INFO    = '#6ECADC'
    SLACK_COLOR_WARNING = '#FFC300'
    SLACK_COLOR_GOOD    = '#3EB991'

    PROJECT_NAME = 'ios-webview-test-app'
  }

  stages {
    stage('Announce') {
      steps {
        slackSend (color: "${env.SLACK_COLOR_INFO}",
                  message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Started* (<${env.BUILD_URL}|Open>)")
      }
    }
    stage('Update submodules') {
      steps {
        sh 'git submodule update --init --recursive'
      }
    }
    stage('Prepare') {
      environment {
        IFRAME_SOURCE="CalWebViewApp/CalWebViewApp/iframe.html"
        PAGE_SOURCE="CalWebViewApp/CalWebViewApp/page.html"

        IFRAME_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/iframe.html"
        PAGE_TARGET="/Library/Server/Web/Data/Sites/Default/CalWebViewApp/page.html"
      }
      steps {
        sh '''
          cp "${IFRAME_SOURCE}" "${IFRAME_TARGET}"
          cp "${PAGE_SOURCE}" "${PAGE_TARGET}"
        '''
        sh '''
          gem update --system
          gem uninstall -Vax --force --no-abort-on-dependent calabash-cucumber
          gem uninstall -Vax --force --no-abort-on-dependent run_loop
        '''
        sh 'bundle update'
      }
    }
    stage('Clean') {
      steps {
        sh 'cd CalWebViewApp; make clean'
      }
    }
    stage('Run tests') {
      steps {
        sh 'bundle exec bin/ci/test-cloud.rb'
        sh 'bundle exec bin/ci/jenkins/cucumber.rb --tags ~@pending'
      }
    }
  }

  post {
    always {
      junit 'CalWebViewApp/reports/**/*.xml'
    }
    aborted {
      echo "Sending 'aborted' message to Slack"
      slackSend (color: "${env.SLACK_COLOR_WARNING}",
                message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Aborted* after ${currentBuild.durationString.replace('and counting', '')}(<${env.BUILD_URL}|Open>)")
    }

    failure {
      echo "Sending 'failed' message to Slack"
      slackSend (color: "${env.SLACK_COLOR_DANGER}",
                message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Failed* after ${currentBuild.durationString.replace('and counting', '')}(<${env.BUILD_URL}|Open>)")
    }

    success {
      echo "Sending 'success' message to Slack"
      slackSend (color: "${env.SLACK_COLOR_GOOD}",
                message: "${env.PROJECT_NAME} [${env.GIT_BRANCH}] #${env.BUILD_NUMBER} *Success* after ${currentBuild.durationString.replace('and counting', '')}(<${env.BUILD_URL}|Open>)")
    }
  }

  options {
    disableConcurrentBuilds()
    timeout(time: 60, unit: 'MINUTES')
    timestamps()
  }
}