#前端页面的须知

##依赖

安装好 `node` 和 `npm` 之后，还需要安装 [yeoman](http://yeoman.io/):

`npm install -g yo`

之后在这个目录中执行

`npm install`
`bower install`

就可以安装好所有的依赖（如果中途没有出错的话）

之后执行

`grunt server` 

就会开启一个静态服务器。

##发布

执行 `grunt build`，发布的内容在 `./dist` 中。





