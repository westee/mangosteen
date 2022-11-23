# 注意修改 user 和 ip
user=mangosteen
ip=$1

frontend_dir=$cache_dir/frontend

time=$(date +'%Y%m%d-%H%M%S')
cache_dir=tmp/deploy_cache
dist=$cache_dir/mangosteen-$time.tar.gz
current_dir=$(dirname $0)
deploy_dir=/home/$user/deploys/$time
gemfile=$current_dir/../Gemfile
gemfile_lock=$current_dir/../Gemfile.lock
vendor_cache_dir=$current_dir/../vendor/cache

function title {
  echo 
  echo "###############################################################################"
  echo "## $1"
  echo "###############################################################################" 
  echo 
}

title '打包前端代码'
mkdir -p $frontend_dir
rm -rf $frontend_dir/repo
git clone https://gitee.com/dflk/shanzhu-station.git $frontend_dir/repo
cd $frontend_dir/repo && pnpm install && pnpm run build; cd -
tar -cz -f "$frontend_dir/dist.tar.gz" -C "$frontend_dir/repo/dist" .


title '打包源代码为压缩文件'
mkdir $cache_dir
bundle cache
tar --exclude="tmp/cache/*" --exclude="tmp/deploy_cache/*" -czv -f $dist *
title '创建远程目录'
ssh $user@$ip "mkdir -p $deploy_dir/vendor"
title '上传压缩文件'
scp $dist $user@$ip:$deploy_dir/
yes | rm $dist
scp $gemfile $user@$ip:$deploy_dir/
scp $gemfile_lock $user@$ip:$deploy_dir/
scp -r $vendor_cache_dir $user@$ip:$deploy_dir/vendor/
title '上传前端代码'
scp "$frontend_dir/dist.tar.gz" $user@$ip:$deploy_dir/
yes | rm -rf $frontend_dir
title '上传 Dockerfile'
scp $current_dir/../config/host.Dockerfile $user@$ip:$deploy_dir/Dockerfile
scp $current_dir/../config/nginx.default.conf $user@$ip:$deploy_dir/
title '上传 setup 脚本'
scp $current_dir/setup_remote.sh $user@$ip:$deploy_dir/
title '上传版本号'
ssh $user@$ip "echo $time > $deploy_dir/version"
title '执行远程脚本'
ssh $user@$ip "export version=$time; /bin/bash $deploy_dir/setup_remote.sh"