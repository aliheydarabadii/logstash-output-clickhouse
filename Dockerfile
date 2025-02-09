FROM logstash:7.13.2


WORKDIR /data/logstash-output-clickhouse/

COPY ./ .

# 使用 root 用户访问
USER root

#RUN logstash-plugin install logstash-filter-json_encode \
#    && logstash-plugin install logstash-filter-prune
RUN logstash-plugin install logstash-filter-clone
    # 安装 rubygem（ruby 包管理器）
RUN  yum install rubygems -y \
    # 删除默认的 rubygem 源地址
    && gem sources -r https://rubygems.org/ \
    # 添加 rubygem 国内源地址

    # 更新源的缓存
    && gem sources -u \
    && gem build logstash-output-clickhouse.gemspec \
    &&  logstash-plugin install --no-verify logstash-output-clickhouse-0.1.5.gem
    #&& logstash-plugin install logstash-output-clickhouse-0.1.6.gem \
    #&& rm -f ./clickhouse-plugin \
RUN logstash-plugin install logstash-filter-json_encode
 #   && ln -sv /usr/share/zoneinfo/Asia/Chongqing /etc/localtime \
  #  && echo "Asia/Chongqing" > /etc/timezone


