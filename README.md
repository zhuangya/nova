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
id: tees/pure_color
name: Pure Color T-Shirts
description: |
	I am a T-Shirt
	DO NOT typo as T-Shit
variants:
	white: White Tee
	black: Black Tee
price:
	white: 133.22
	black: 122.34
inventory:
	white: 
		s:0
		m:10
		l:2
		xl:20
	black:
		s:0
		m:0
		xl:10
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
id: tees/pure_color
name: Pure Color T-Shirts
description: |
	I am a T-Shirt
	DO NOT typo as T-Shit
variants:
	white: White Tee
	black: Black Tee
price:
	white: 133.22
	black: 122.34
inventory:
	white: 
		s:0
		m:10
		l:2
		xl:20
	black:
		s:0
		m:0
		xl:10
```

POST /api/admin/data/:id
---
update product data
post fileds you need to update:

```
name: Changed Name
price: 100000000.0
inventory: 100

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
