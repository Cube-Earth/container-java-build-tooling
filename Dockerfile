FROM cubeearth/oracle-java8

ENV MAVEN_HOME=/opt/maven \
    GRADLE_HOME=/opt/gradle \
    HELM_HOME=/opt/helm \
    PATH=$PATH:/opt/maven/bin:/opt/gradle/bin:/opt/helm/bin

RUN apk --no-cache add git jq curl bash zip xmlstarlet && \
	wget -O- https://www-eu.apache.org/dist/maven/maven-3/3.6.0/binaries/apache-maven-3.6.0-bin.tar.gz | tar xz -C /opt && \
    ln -s /opt/apache-maven-* /opt/maven && \
    wget https://services.gradle.org/distributions/gradle-5.1.1-bin.zip && \
    cd /opt && \
    unzip /tmp/gradle*.zip && rm /tmp/gradle*.zip && \
    ln -s /opt/gradle-* /opt/gradle && \
	a=$(curl -sL https://github.com/helm/helm/releases | grep href | grep linux-amd64 | head -n 1 | awk 'match($0," href=\"[^\\\"]*\"") { print substr($0, RSTART+7, RLENGTH-8)  }') && \
	mkdir -p /opt/helm/bin && \
	curl -sL "$a" | tar xz --strip-component=1 -C /opt/helm/bin && \
	helm init -c && \
	helm plugin install --version master https://github.com/sonatype-nexus-community/helm-nexus-push.git && \
	echo "=== maven ===============" && \
	mvn -v && \
	echo "=== gradle ===============" && \
	gradle -v && \
	echo "=== helm ===============" && \
	helm version --client
	