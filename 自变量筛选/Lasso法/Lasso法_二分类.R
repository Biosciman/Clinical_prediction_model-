# 参考 https://ayueme.github.io/R_clinical_model/lasso.html
library('glmnet')

data(BinomialExample)
x <- BinomialExample$x
# y为二分类资料
y <- BinomialExample$y

# dim显示row & column总数
dim(x)
class(x)
class(y)
"""
glmnet需要的自变量格式，需要是matrix或者稀疏矩阵格式
family用来指定不同的模型类型，对于二分类数据，应该选择binomial。
amily的其他选项如下：“gaussian”（默认）, “poisson”, “multinomial”, “cox”, “mgaussian”。
alpha=1表示为lasso，0表示为岭回归，在0~1之间为弹性网络
nlambda设置最大迭代次数1000次，但模型不一定迭代1000次，它会收敛于最优解，即若在1000次前得到最优结果后会停止迭代
"""
fit <- glmnet(x, y, alpha = 1,family = "binomial", nlambda = 1000)
"""
结果中第一列为自由度（Df）,第二列为解释偏差百分比（%Dev），第三列为lambda
结果收敛于847次迭代，此时Df为30，%Dev为99.66，lambda为0.000099
"""
options(max.print=1000) 
print(fit)
"""
查询各个自变量的系数，每一个变量系数均不为0，即本次lasso没有剔除任何自变量
coef()有一个exact参数，如果exact = TRUE，那么当一个lambda不在默认的lambda值中时，函数会重新使用这个lambda值拟合模型然后给出结果
如果exact = FALSE（默认值），那么会使用线性插值给出结果
"""
coef(object = fit, s=0.000099)
"""
Lasso评分，即预测新数据
link：线性预测值，默认是这个
response：预测概率
class：预测类别
"""
Lasso_score <- predict(fit,newx = x,type='class',s=0.000099)
# 可视化各个变量系数的变化
"""
这个图形中的每一条线都代表1个变量，并且展示了在不同的L1范数（L1 Norm）下该变量的系数变化。
这个图下面的横坐标是L1范数，上面的横坐标是L1范数下对应的非零系数的个数,
比如当L1范数是20时，对应的非零系数有27个，也就是此时可以有27个变量保留下来。左侧纵坐标是变量的系数值。
在使用exact = TRUE时，需要提供x和y，因为需要重新拟合模型。
比如coef(fit, s = 0.08, exact = TRUE, x=x, y=y)
"""
plot(fit,label = T)
# norm：横坐标是L1 norm，这个是默认值；lambda：横坐标是log-lambda；dev：横坐标是模型解释的%deviance
plot(fit, xvar = "lambda")
plot(fit, xvar = "dev", label = TRUE)
