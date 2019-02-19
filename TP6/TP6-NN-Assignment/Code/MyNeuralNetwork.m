classdef MyNeuralNetwork < handle
    %NEURALNETWORK Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Layers
        Sigmas
        W
        b
        Z
        A
        dW
        db
        maxTrain
        minTrain
    end
    
    methods
        function obj = MyNeuralNetwork(Layers, Sigmas)
            %NEURALNETWORK Construct an instance of this class
            %   Detailed explanation goes here
            obj.Layers = Layers;
            obj.Sigmas = Sigmas;
            
            obj.maxTrain = ones(Layers{1}, 1)*realmin;
            obj.minTrain = ones(Layers{1}, 1)*realmax;
        end
        
        function [YHat] = feedforward(obj, X)
            %UNTITLED Summary of this function goes here
            %   Detailed explanation goes here
            L = length(obj.Sigmas);
            obj.A = cell(L+1,1); % l layers plus the input
            obj.Z = cell(L,1);
            obj.A{1} = X;

            for l=1:L
                obj.Z{l} = obj.W{l}*obj.A{l} + obj.b{l};
                obj.A{l+1} = apply_activation(obj.Z{l}, obj.Sigmas{l}, true);
            end
            YHat = obj.A{end};
        end
        
        function [dZ] = backpropagation(obj, Y, YHat, typeCost)
            %BACKPROPAGATION Summary of this function goes here
            %   Detailed explanation goes here
            M = size(Y,2);
            L = length(obj.Sigmas);
            obj.db = cell(L,1);
            obj.dW = cell(L,1);
            dZ = cell(L,1);

            dZ{end} = cost_derivative(Y, YHat,  typeCost, obj.Sigmas{end});
            obj.db{end} = 1/M*sum(dZ{end},2);
            obj.dW{end} = 1/M*dZ{end}*obj.A{end-1}';

            for l=L-1:-1:1
                dZ{l} = obj.W{l+1}'*dZ{l+1}.*apply_activation(obj.Z{l}, obj.Sigmas{l}, false);
                obj.db{l} = 1/M*sum(dZ{l},2);
                obj.dW{l} = 1/M*dZ{l}*obj.A{l}';
            end
        end
        
        function [] = update_parameters(obj, eta)
            for i=1:length(obj.Sigmas)
                obj.W{i} = obj.W{i} - eta * obj.dW{i};
                obj.b{i} = obj.b{i} - eta * obj.db{i};
            end
        end
        
        function [a] = plot_activation(obj, l, i, osize)
            a = obj.A{l}(i,:);
            a = reshape(a, osize);
        end
        
        function [] = batch_train(obj, X, Y, eta, CostFunction)
            %UPDATE Summary of this function goes here
            %   Detailed explanation goes here
            YHat = obj.feedforward(X);
            obj.backpropagation(Y, YHat, CostFunction);
            obj.update_parameters(eta)
        end
        
        function [Ctrain, Ctest] = train(obj, Xtrain, Ytrain, Xtest, Ytest, epochs, batch_size, eta, CostFunction)
            %TRAIN Summary of this function goes here
            %   Detailed explanation goes here

            M = size(Xtrain,2);
            Ctrain = zeros(epochs,1);
            Ctest = zeros(epochs,1);

            for t=1:epochs
                % extract batch at random
                idx = randperm(M, batch_size);
                X = Xtrain(:,idx);
                Y = Ytrain(:,idx);
                obj.batch_train(X, Y, eta, CostFunction);

                % evaluate the cost
                Ctrain(t) = obj.evaluate(X, Y, CostFunction);
                Ctest(t) = obj.evaluate(Xtest, Ytest, CostFunction);

                % plot things
            end
        end
        
        function [c] = evaluate(obj, Xtest, Ytest, CostFunction)
            %EVALUATE Summary of this function goes here
            %   Detailed explanation goes here
            YHat = obj.feedforward(Xtest);
            c = cost_function(Ytest, YHat, CostFunction);
        end
    end
end

