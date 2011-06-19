net = new brain.NeuralNetwork()

net.train([{input: {r:1, g:0.65, b:0},  output: {orange: 1}},
           {input: {r:0, g:0.54, b:0},  output: {green: 1}},
           {input: {r:0.6, g:1, b:0.5}, output: {green: 1}},
           {input: {r:0.67, g:0, b:1},  output: {purple: 1}}])

output = net.run({r:1, g:1, b:0})
