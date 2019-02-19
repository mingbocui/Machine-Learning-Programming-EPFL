function [] = plot_digits(data)
figure                                          
colormap(gray)                                 
for i = 1:25                            
    subplot(5,5,i)                             
    digit = reshape(data(:,i), [28,28])';    
    imagesc(digit)                
end
end

