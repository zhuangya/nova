Test API
===

http://benzex.com/api



Schema
===

item (in cart): `[:categlogy]/[:name]/[:variant]/[:size]`

eg.: `tee/pure_color/white/xxl`

---------

metadata (json): `/data/[:categlogy]/[:name]`

metadata (yaml): `/data/[:categlogy]/[:name]/metadata.yml`

eg.: `/data/tee/pure_color`

---------

picture: `/photo/[:categlogy]/[:name]/[:variant]_[:filename](?schema=[:schema])`

eg.: `/photo/tee/pure_color/white_main.jpg?schema=cover120`

---------

product
---
```
id: tee/pure_color
name: Pure Color T-Shirts
description: |
    I am a T-Shirt
    DO NOT typo as T-Shit
variants:
	-
    	name: white
        screen_name: White Tee
        sizes:
            -
            	name: s
                price: 233
                inventory: 0
            -
            	name: m
                price: 233
                inventory: 10
            -
            	name: l
                price: 233
                inventory: 30
            -	
            	name: xl
                price: 234
                inventory: 20
    -
    	name: black
        screen_name: Black Tee
        sizes:
            -
            	name: s
                price: 233
                inventory: 0
            -
            	name: m
                price: 233
                inventory: 10
            -
            	name: l
                price: 233
                inventory: 30
            -	
            	name: xl
                price: 234
                inventory: 20
```

cart
---
```
[{
	name: tees/pure_color/white/xxl
	quantity: 1
	unit_price: 100.0
}]
```


order
---
```
id: 1234567
alipay_txid: 890123456
items:
	[<cart>]
status: processing
shipping: "123456789”
address: some where in the world
phone: 18600000000
```

API
===

GET /auth/weibo[?url=/some/where#you_want]
---
login with weibo OAuth, redir to url after success, defaults to '/'

GET /api/user
---
returns current user information

GET /data
---
returns an array of all products
page with offset & count param.

GET /data/[:categlogy]
---
get product data of an categlogy

GET /data/[:categlogy]/[:name]
---
get detailed product data, including inventory.

GET /data/video
---
return slice of /data/video.json

GET /api/cart
---
get cart


POST /api/cart
---
add to cart


DELETE /api/cart
---
remove items from cart


POST /api/order
---
create order


GET /api/order
---
get orders of user


admin api
===

POST /api/admin/video
---
update /data/video.json

```
{"name":"hello","url":"world"}
```

to delete a video, post an object with only name and leave url undefined.

POST /api/admin/data
---
create new product

```
id: tee/pure_color
name: Pure Color T-Shirts
description: |
    I am a T-Shirt
    DO NOT typo as T-Shit
variants:
	-
    	name: white
        screen_name: White Tee
        sizes:
            -
            	name: s
                price: 233
                inventory: 0
            -
            	name: m
                price: 233
                inventory: 10
            -
            	name: l
                price: 233
                inventory: 30
            -	
            	name: xl
                price: 234
                inventory: 20
    -
    	name: black
        screen_name: Black Tee
        sizes:
            -
            	name: s
                price: 233
                inventory: 0
            -
            	name: m
                price: 233
                inventory: 10
            -
            	name: l
                price: 233
                inventory: 30
            -	
            	name: xl
                price: 234
                inventory: 20
```

POST /api/admin/data/:id
---
update product data
post fileds you need to update:

```
name: Changed Name
```

POST /api/admin/data/:id/upload
---
upload photos to /data/:id/:name

```
<input name='name' value='cover.jpg'>
<input name='payload' type='file'>
```

POST /api/admin/data/reload
---
regenerate cache

call this after create/update product data, and after all images were uploaded.

GET /api/admin/order
---
return all orders

GET /api/admin/order/:id
---
return order info

POST /api/admin/order/:id
---
update order


GET /api/admin/users?page=0&size=30
---
returns a list of users


MISC
---

**关于metadata中的 price 和 ivventory 字段定义如下**

1. 如果值是一个数字，则所有分类/尺寸共享一个值，
1. 如果对应的 size值存在 则所有分类共享这个值
1. 如果对应的 variant值存在，并且是一个数字，则此分类下的所有尺寸共享这个值
1. 最后是用 [variant][size] 进行最精确的匹配
