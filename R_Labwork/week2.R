c(2,3,,5,7)+c(-2,-3,-5,8)

c(2,3,,5,7)+c(8,9)

c(2,3,,5,7)+c(8,9,10)

c(2,3,,5,7)-c(-2,-3,-5,8)

c(2,3,,5,7)-c(8,9)

c(2,3,,5,7)-c(8,9,10)

c(2,3,,5,7)*c(-2,-3,-5,8)

c(2,3,,5,7)*c(8,9)

c(2,3,,5,7)*c(8,9,10)

c(24,20,8,16)/c(3,4,2,8)

c(24,20,8,16)/c(4,2)

c(24,20,8,16)/c(4,2,8)

x=20
is.numeric(x)
is.character(x)

y="apple"
is.character(y)
is.numeric(x)

z=as.character(x)
is.numeric(z)
is.character(x)

z

a=is.numeric(y)
is.character(a)
is.numeric(a)

a

y=1,2,3,4,5
y=c(1,2,3,4,5)


x=6
x
mode(x)

y="apple"
y
mode(y)

storage.mode(x)

x=TRUE
storage.mode(x)

storage.mode(y)

3/0
5+Inf
x=5+Inf
is.finite(x)
is.infinite(x)

c(2,3,5,7)+10
c(2,3,5,7)-10
c(2,3,5,7)*10
c(2,3,5,7)/10