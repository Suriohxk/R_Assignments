for(i in 1:5) {print(i^2)}
for(i in c(2,4,6,7)) {print(i^2)}

x=c(2,4,6,8,10,12)

excount = function(x) {
count = 0
for(xval in x) {
if(xval/2 >3)
count=count+1
}
print(count)
}
excount(x)

child=c("c1","c2","c3")
sweet=c("s1","s2","s3")

for(x in child) {
for(y in sweet ) {
print(paste(x,y))
}
}

drink = c("coffee","lemonade","tea","juice")

for(x in drink) {
if(x=="tea") {
break
}
print(x)
}

for(x in drink) {
if(x=="tea") {
next
}
print(x)
}

i=1
while(i<10) {
print(i^2)
i=i+2
}

sf = function() {
s=0
n=22
while(n<=25) {
s=s+n
n=n+1 }
print(paste("The sum of numbers received from the While Loop: ",s))
}
sf()


i=1
repeat{
print(i^2)
i=i+2
if(i>10)
break
}

i=1
repeat{
i=i+1
if(i<10) next 
print(i^2) 
if(i>=13) break
}

abc = function(x){
x^2}

abc(3)
abc(6)
abc(9)

abc = function(x,y){
x^2+y^2}

abc(3,4)
abc(10,10)
abc(-2,-3)

abc = function(x){
sin(x)^2 + cos(x)^2 + x
}

abc(9)
abc(99)
abc(-15)

abc = function() {
for(i in 1:3) {
print(i^3)
}
}

abc()

seq(from =2 ,to=4)

seq(from =4 ,to=2)

seq(from =-4 ,to=4)

seq(from =10 ,to=20,by=2)

seq(from =20 ,to=10,by=-2)

seq(from=3,to=-2,by=-0.5)

seq(to=10,length=10)

seq(from=10,length=10)

seq(from=10,length=10,by=0.1)

seq(from=10,length=10,by=-2)

seq(from=10,length=5,by=-.2)
