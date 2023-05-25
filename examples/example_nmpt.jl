using Peccon, StatsPlots, Statistics, Distributions, IterTools, Plots
Tickers = ["IUSA.AS", "IBCI.AS", "IEMA.AS", "WTCH.AS", "VWRL.AS"]


data = data_alpha(Tickers, "0VS2G38H6PKP03GX", 1008)

stock_price = data[1][:, :close]
stock_price2 = data[2][:,:close]
stock_price3 = data[3][:,:close]


X = [float(1)]
for (i, j) in partition(stock_price, 2,1)
    x = float(i/j)
    append!(X,x )
end


X2 = [float(1)]
for (i, j) in partition(stock_price2, 2,1)
    x = float(i/j)
    append!(X2,x )
end

X3 = [float(1)]
for (i, j) in partition(stock_price3, 2,1)
    x = float(i/j)
    append!(X3,x )
end



histogram(X)
histogram!(X2)
histogram!(X3)


fit_mle(Normal, X)
fit_mle(LogNormal, X)


Y = rand(Normal( 1.0003283948,0.0113292031), 1007)

Z = rand(LogNormal(0.0002637643, 0.01139101567), 1007)

histogram(Y)
histogram(Z)
qqplot(X,Y)
qqplot!(X,Z)


size(X)[1]

### create a neural network 


using Flux

model_test = Chain( Dense(size(X)[1] => 42 , σ), 
                Dense(42 => 1, softplus), 
                softmax)


returns = daily_returns(data, Tickers)


loss(γ, X, n) = sum(1/(X .- γ )) * sum((log.(X .- γ))) - sum((X .- γ).^2) + 1/n*sum(log.(X .- 0.8))^2 - n*sum((log.(X .- γ ))./(X .- γ))




loss(1, stock_price, 1008)
loss(0.000000000000988, stock_price2, 1008)

loss(0.01, stock_price3, 1008)

