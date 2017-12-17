%%Program to encode images using DCT
%%Author: Siffi Singh
%%Date: 09/11/2017

%%Reading .raw file
function y= threshold(filename, step_size, coefficents)
if true
    row = 512; col=512;
X = fopen(filename, 'r');
I = fread(X, row*col, 'uint8=>uint8');
Z = reshape(I, row, col);
Z = Z';
k = imshow(Z);
M = Z;
end

Coeff=zeros(64,64,coefficents);

%%Encoding
for i=1:8:512
    for j=1:8:512
        A = Z(i:i+7, j:j+7);
        B = dct2(A);
        
        for p=1:8
            for q=1:8
                if B(p,q)<-2048 
                    B(p,q) = -2048;
                elseif B(p,q)>2047
                    B(p,q) = 2047;  
                end                
            end
        end
        
        Zig_M = zigzag(B);
        for n=1:coefficents %%Zigzag
            Coeff(((i-1)/8+1),((j-1)/8+1),n)=Zig_M(n);
        end            
    end    
end

%%Quantization
for i= 1:64
    for j=1:64
        for n = 1:coefficents
            if Coeff(i,j,n)<0
            Coeff(i,j,n) = (Coeff(i,j,n) + (-1)*((step_size/2)-(2^-12)))/step_size;
            else
            Coeff(i,j,n) = (Coeff(i,j,n) + (((step_size/2)-(2^-12))))/step_size;
            end 
        end
    end
end

%%Inverse Quantization
Coeff = Coeff*step_size;

Reconstruct=zeros(64,1);
Out_M=zeros(512,512,'uint8');
Inv_ZigM =zeros(8,8);

%%Decoding
for i=1:8:512
    for j=1:8:512
        for n=1:coefficents %%Zigzag
            Reconstruct(n)=Coeff(((i-1)/8+1),((j-1)/8+1),n);
            %Coeff(i,j,n)=Zig_M(n);
        end
        Inv_ZigM = invzigzag(Reconstruct,8,8);        
        Inv_ZigM = idct2(Inv_ZigM);
        Out_M(i:i+7, j:j+7)=uint8(Inv_ZigM);
    end
end

imwrite(Out_M,'happy.bmp');
F = imshow(Out_M);
Out_M;

%%MSE Calculation
MSE =0;
for i=1:512
    for j=1:512
        MSE = MSE + (double(Out_M(i,j))-double(Z(i,j)))^2;
    end
end

MSE = MSE/(512*512);
y=MSE;


end