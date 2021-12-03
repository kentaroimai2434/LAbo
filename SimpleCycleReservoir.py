import numpy as np
import random
from scipy import linalg
from tqdm import tqdm 

class SimpleCycleReservoir:
    
    def __init__(self, inputs, target, num_reservoir_layer, num_input_nodes, num_reservoir_nodes, num_output_nodes, 
                 leak_rate, lambda0, num_epoch, random_connect=False, activator=np.tanh, ):
        self.inputs = inputs
        self.target = target
        self.log_reservoir_nodes = np.zeros(((num_reservoir_layer, len(inputs), num_reservoir_nodes)))
        self.rc = random_connect

        # setup weights
        self.weights_input = self._generate_input_weights(num_reservoir_nodes, num_input_nodes)
        self.weights_reservoir = self._generate_reservoir_weights(num_reservoir_layer, num_reservoir_nodes)
        self.reservoir2reservoir  = self._generate_reservoir2reservoir(num_reservoir_layer,num_reservoir_nodes)
        self.weights_output = np.zeros([ num_output_nodes,num_reservoir_nodes])

        # number of node
        self.num_reservoir_layer = num_reservoir_layer
        self.num_input_nodes = num_input_nodes
        self.num_reservoir_nodes = num_reservoir_nodes
        self.num_output_nodes = num_output_nodes

        self.leak_rate = leak_rate
        self.lambda0 = lambda0
        self.activator = activator
        self.epoch = num_epoch


    def _get_next_reservoir_nodes(self, inputs, current_state, l):
        if l == 0:
            next_state = (1 - self.leak_rate) * current_state
            next_state += self.leak_rate * (np.array([inputs]) @ self.weights_input
                                            + current_state @ self.weights_reservoir[0])
            
        else:
            next_state = (1 - self.leak_rate) * current_state
            next_state += self.leak_rate * (inputs @ self.reservoir2reservoir[l-1] 
                                            + current_state @ self.weights_reservoir[l])
            
        return self.activator(next_state)


    def _update_weights_output(self):
        # Ridge Regression
        E_lambda0 = np.identity(self.num_reservoir_nodes) * self.lambda0
        inv_x = np.linalg.inv(self.log_reservoir_nodes[-1].T @ self.log_reservoir_nodes[-1] + E_lambda0)
        # update weights of output layer
        self.weights_output = (inv_x @ self.log_reservoir_nodes[-1].T) @ self.target


    def train(self):
        for e in range(self.epoch):
            num = 0
            for input in self.inputs:
                for l in range(self.num_reservoir_layer):
                    current_state = np.array(self.log_reservoir_nodes[l][num-1])
                    if l == 0:
                        state = self._get_next_reservoir_nodes(input, current_state, l)
                        self.log_reservoir_nodes[l][num] = state
                    
                    else:
                        state = self._get_next_reservoir_nodes(self.log_reservoir_nodes[l-1][num], current_state, l)
                        self.log_reservoir_nodes[l][num] = state
                num+=1
            self._update_weights_output()
        


    def get_train_result(self):
        train_result = []
        for inputs in self.inputs:
            for l in range(self.num_reservoir_layer):
                reservoir_nodes = self.log_reservoir_nodes[l][-1] # 訓練の結果得た最後の内部状態を取得
                inputs = self._get_next_reservoir_nodes(inputs, reservoir_nodes,l)
            train_result.append(self.get_output(inputs))
        return train_result 


    def predict(self, test_input):
        predicted_outputs=[]
        for inputs in test_input:
            for l in range(self.num_reservoir_layer):
                reservoir_nodes = self.log_reservoir_nodes[l][-1] # 訓練の結果得た最後の内部状態を取得
                inputs = self._get_next_reservoir_nodes(inputs, reservoir_nodes,l)
            predicted_outputs.append(self.get_output(inputs))
        return predicted_outputs 

    # get output of current state
    def get_output(self, reservoir_nodes):
        return reservoir_nodes @ self.weights_output

    #入力層重み
    def _generate_input_weights(self, Nr, Ni):
        return np.random.uniform(-1,1, size=(Ni,Nr))

    # Reservoir層内の重み
    def _generate_reservoir_weights(self, layer_num, num_nodes):
        weight = np.zeros((layer_num, num_nodes, num_nodes))
        r = random.uniform(-1,1)
        PM=[-1,1]
        for l in range(layer_num):
            for i in range(num_nodes):
                if i<num_nodes-1:
                    weight[l,i+1,i] = r*random.choice(PM)
                else:
                    weight[l,0,num_nodes-1] = r*random.choice(PM)
        return weight
    
    #reservoir間の重み
    def _generate_reservoir2reservoir(self, layer_num, num_nodes):
        if self.rc == True:
            weight_res2res = np.zeros((layer_num-1, num_nodes, num_nodes))
            for l in range(layer_num-1):
                weight_connect=list(range(num_nodes))
                for i in range(num_nodes):
                    num = weight_connect.pop(random.randint(0,len(weight_connect)-1))
                    weight_res2res[l,i,num] = random.uniform(-1,1)
            
            
        else:
            weight_res2res = np.zeros((layer_num-1, num_nodes, num_nodes))
            for l in range(layer_num-1):
                for i in range(num_nodes):
                    weight_res2res[l,i,i] = random.uniform(-1,1)
        
        return weight_res2res