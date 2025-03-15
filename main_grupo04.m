clc;
clear all;
close all;

image = imread("SAR Image with targets.jpg");
imshow(image);

image = double(image);
image_gray = (image(:,:,1).^2+ image(:,:,2).^2 + image(:,:,3).^2).^(0.5);

portion = image(100:150, 1:51, :);
med = mean(portion, "all");
des = std(portion(:));

const = input("Digite o tamanho do filtro: ");
while(const<1 || mod(const, 2)~=0 || const>300)
    const = input("Digite um tamanho válido: ");
end

direction = input("Digite a direção (1-vertical, 2-horizontal, 3-diagonal esquerda, 4-diagonal direita): ");
while(direction<1 || direction>4)
    direction = input("Digite uma direção válida: ");
end

if(direction == 1)
MASK_HPF = ones(const,const);
MASK_HPF(1:const,1:const/2) = -1;

elseif(direction == 2)
MASK_HPF = ones(const,const);
MASK_HPF(1:const/2,1:const) = -1;

elseif(direction == 3)

MASK_HPF = zeros(const,const);

    for i = 1:const

        for j = 1:const

            if(i == j)
                MASK_HPF(i,j) = 1;
            end

            if(i ~= j)
                MASK_HPF(i,j) = -(1/(const-1));
            end

        end

    end

elseif(direction == 4)

MASK_HPF = zeros(const,const);

    for i = 1:const

        for j = 1:const

            if(i+j == const+1)
                MASK_HPF(i,j) = 1;
            end

            if(i+j ~= const+1)
                MASK_HPF(i,j) = -(1/(const-1));
            end

        end

    end
end

MASK_HPF = MASK_HPF / sum(abs(MASK_HPF(:)));
MASK_LPF = 1 - MASK_HPF;
I_LPF = filter2(MASK_LPF, image_gray);

figure(2);
imagesc(I_LPF);
colormap("gray");

I_HPF = filter2(MASK_HPF, image_gray);

figure(3);
imagesc(I_HPF);
colormap("gray");

image3 = image;

for i = 1:1044

    for j = 1:1117

        if((i+const)<1044 && (j+const)<1117)

            image2 = image(i:const+i,j:const+j,:);

            media = mean(image2,"all");

            desvio = std(image2(:));

            if((102.9297+10 > media && 102.9297-10 < media) && (desvio < 11.9400+2 && desvio > 11.9400-2))
                image3(i:const+i,j:const+j,3) = 255;
            end

            if((130.9297+6 > media && 130.9297-6 < media) && (desvio < 11.9400+1.5 && desvio > 11.9400-1.5))
                image3(i:const+i,j:const+j,3) = 255;
            end

            if((77.2930+4 > media && 77.2930-4 < media) && (desvio < 6.0413+2 && desvio > 6.0413-2))
                image3(i:const+i,j:const+j,3) = 255;
            end

            if(i+100<1044 && j+100<1117)
    
                if((53.2470+6 > media && 53.2470-6 < media) && (desvio < 30.0655+5 && desvio > 30.0655-5))
                    image3(i:75+i,j:75+j,1) = 255;
                end

            end

            if(i+100<1044 && j+100<1117) 

                if((93.6065+3 > media && 93.6065-3 < media) && (desvio < 8.2708+1 && desvio > 8.2708-1))
                    image3(i:100+i,j:100+j,2) = 255;
                end

            end

            if((150.0842+15 > media && 150.0842-15 < media) && (desvio < 31.9174+10 && desvio > 31.9174-10))
                image3(i:const+i,j:const+j,2) = 255;
            end

        end

    end

end

image4 = image3;

for i = 1:1044

    for j = 1:1117

        if((i+const)<1044 && (j+const)<1117)

            meanR = mean(image3(i:const+i,j:const+j,1),"all");
            meanG = mean(image3(i:const+i,j:const+j,2),"all");
            meanB = mean(image3(i:const+i,j:const+j,3),"all");
    
            if(meanR > meanG && meanR > meanB && all(image3(i:const+i,j:const+j,1) == 255, "all"))
                image4(i:const+i,j:const+j,1) = 255;
                image4(i:const+i,j:const+j,2) = image(i:const+i,j:const+j,2);
                image4(i:const+i,j:const+j,3) = image(i:const+i,j:const+j,3);
            end

            if(meanG > meanR && meanG > meanB && all(image3(i:const+i,j:const+j,2) == 255, "all"))
                image4(i:const+i,j:const+j,1) = image(i:const+i,j:const+j,1);
                image4(i:const+i,j:const+j,2) = 255;
                image4(i:const+i,j:const+j,3) = image(i:const+i,j:const+j,3);
            end

            if(meanB > meanR && meanB > meanG && all(image3(i:const+i,j:const+j,3) == 255 , "all"))
                image4(i:const+i,j:const+j,1) = image(i:const+i,j:const+j,1);
                image4(i:const+i,j:const+j,2) = image(i:const+i,j:const+j,2);
                image4(i:const+i,j:const+j,3) = 255;
            end

         end

    end
end


figure(4);
imagesc(image3/255);

figure(5);
imagesc(image4/255);