FROM registry.access.redhat.com/ubi8/openjdk-8:1.10-1
#ENV JBOSS_HOME=/home/jboss/
EXPOSE 8181
USER root
RUN microdnf update java-1.8.0-devel \
 && microdnf install curl gzip -y \
 && usermod -g root -G jboss jboss
RUN curl http://nexus3-nexus3.cloudappsdesa.fiduprevisora.com.co/repository/maven-releases/fiduprevisora/image/fuse78v2.tar.gz/1.0/fuse78v2.tar.gz-1.0.gz --output /tmp/fuse.tar.gz
RUN mkdir -p /home/jboss/.m2 \
 && tar -xzvf /tmp/fuse.tar.gz -C /opt/ \
 && rm -rf /tmp/fuse.tar.gz
COPY m2 /home/jboss/m2
COPY docker-entrypoint.sh /home/jboss/docker-entrypoint.sh
COPY exposition-fiduprevisora-peoplesoft-1.0.jar /opt/fuse78/deploy/
RUN chmod a+x /home/jboss/docker-entrypoint.sh \
 && mv /home/jboss/m2 /home/jboss/.m2 \
 && chmod -R a+x /opt/fuse78/deploy \
 && chmod -R a+w /opt/fuse78/data/log \
 && chown -R jboss:root /opt/fuse78 \
 && chmod -R "g+rwX" /home/jboss \
 && chown -R jboss:root /home/jboss \
 && chmod 664 /etc/passwd
USER 185
ENTRYPOINT ["/home/jboss/docker-entrypoint.sh"]


