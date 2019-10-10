FROM java:8-alpine
LABEL maintainer="Stepan Kuzmin <to.stepan.kuzmin@gmail.com>"

ENV OTP_VERSION=1.4.0
ENV JAVA_OPTIONS=-Xmx1G

ADD http://central.maven.org/maven2/org/opentripplanner/otp/$OTP_VERSION/otp-$OTP_VERSION-shaded.jar /usr/local/share/java/

RUN ln -s otp-$OTP_VERSION-shaded.jar /usr/local/share/java/otp.jar

COPY otp /usr/local/bin/

EXPOSE 8080

ENTRYPOINT ["otp"]
CMD ["--help"]