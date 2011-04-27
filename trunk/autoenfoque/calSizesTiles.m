function [sizes,saveprofV,saveprofH] = calSizesTiles(img,th,tilesize,plotit)
% function sizes = calSizesTiles(img,th,tilesize,plotit)
%
%   This function binarizes the input image and calculates the
%   size of projected horizontal and vertical profiles. To mitigate
%   large errors of estimation in size of object's profiles, the image
%   can be divided in several rectangular tiles, which delivers as many
%   profile sizes as tiles (vertical and horizontal) in which the
%   image is divided.
%
%   img - input image.
%   th - threshold for binarizing accorging to image range.
%   tilesize - short side (in pixels) of rectangular tiles (same for V&H).
%   plotit - number figure where results are plotted (0 plots nothing).
%
%   Rafael Redondo May-2010 (c).
%

switch nargin
    case 1
        th = max(max(img));
        tilesize = max(size(img));
        plotit = 0;
    case 2 
        tilesize = max(size(img));
        plotit = 0;
    case 3
        plotit = 0;
end

imgBin = img;
imgBin(imgBin<th)=0;
imgBin(imgBin>0)=1;

sizes = zeros(1,0);
saveprofH = zeros(0,0);
saveprofV = zeros(0,0);

for d = 1:2
    ntile(d) = ceil(size(imgBin,d)/tilesize);
    for t = 0:ntile(d)-1
        if (t+1)*tilesize>size(imgBin,d)
            coord_max = size(imgBin,d);
        else coord_max = (t+1)*tilesize;
        end
        if d==1
           tile = imgBin(t*tilesize+1:coord_max,1:size(imgBin,2));
           prof = sum(tile,1);
           saveprofH = [saveprofH;prof];
        else
           tile = imgBin(1:size(imgBin,1),t*tilesize+1:coord_max);
           prof = sum(tile,2);
           saveprofV = [saveprofV,prof];
        end

        cont = 0;
        for i = 1:length(prof)
            if prof(i)>0
                cont = cont + 1;
            else
                if cont>0
                    sizes = [sizes, cont];
                    cont = 0;
                end
            end
        end
        if prof(i)
            sizes = [sizes, cont];
        end
    end
end

if isempty(sizes)
   sizes = 0;
end

if plotit
   figure(plotit);   
   set(gcf,'Position',[50 50 1050 700]);
   subplot(ntile(1)*2,ntile(2)*2,[1 ntile(2) ntile(2)*2*(ntile(1)-1)+1])
   imagesc(img)
   title(['Input image']);
   for i=1:ntile(2)
       subplot(ntile(1)*2,ntile(2)*2,[ntile(2)+i ntile(2)*2*(ntile(1)-1)+ntile(2)+i])
       barh(flipud(saveprofV(:,i)))
       ylim([1,size(img,1)+1])
       xlim([0,tilesize])
       %set(gca,'XColor',[1 1 1])
       %set(gca,'YColor',[1 1 1])
       set(gca,'XTick',[])
       set(gca,'YTick',[])
       %set(gca,'FontSize',0.5);
       set(gca,'LineWidth',1.5);
       %axis off
       box on
   end
   for i=1:ntile(1)
       subplot(ntile(1)*2,ntile(2)*2,[ntile(2)*2*(ntile(1)+i-1)+1 ntile(2)*2*(ntile(1)+i-1)+ntile(2)])
       bar(saveprofH(i,:))
       xlim([1,size(img,2)])
       ylim([0,tilesize])
       set(gca,'XTick',[])
       set(gca,'YTick',[])
       set(gca,'LineWidth',1.5)
       %axis off
   end
   subplot(ntile(1)*2,ntile(2)*2,[ntile(2)*(2*ntile(1)+1)+1 4*ntile(1)*ntile(2)])
   imagesc(1-imgBin)
%    hold on
    colormap(gray)
%    xlim([1 size(img,2)])
%    ylim([1 size(img,1)])
    grid on
   set(gca,'LineWidth',1.5)
   set(gca,'XTick',1:tilesize:size(img,2),'YTick',1:tilesize:size(img,1))
   set(gca,'YAxisLocation','right')
   title(['Maximum Profile Size = ' num2str(max(sizes)) ]);
end

Vtilesize=[500 500 500 100];
Htilesize=[500 500 200];
    figure(2)
for i=1:size(saveprofV,2)

    bar(flipud(saveprofV(:,i))*3,'k')
    ylim([1,size(img,1)])
       xlim([1,1200])
       %ylim([0,Vtilesize(i)/2])
       %set(gca,'XColor',[1 1 1])
       %set(gca,'YColor',[1 1 1])
       set(gca,'XTick',[],'DataAspectRatioMode','auto','PlotBoxAspectRatio',[1 Vtilesize(i)/1200 1],'CameraViewAngleMode','auto')
       set(gca,'YTick',[])
       %set(gca,'FontSize',0.5);
       %set(gca,'LineWidth',1.5);
       %eval(['print -dpng T:\users\rafa\Matlab\Tuberculosis\BOEgraph\090408--113303-11-G_profV' num2str(i) '.png']);

end
for i=1:size(saveprofH,1)
    bar(saveprofH(i,:)*3,'k')
    ylim([1,size(img,2)])
       xlim([1,1600])
       %ylim([0,Vtilesize(i)/2])
       %set(gca,'XColor',[1 1 1])
       %set(gca,'YColor',[1 1 1])
       set(gca,'XTick',[],'DataAspectRatioMode','auto','PlotBoxAspectRatio',[1 Htilesize(i)/1600 1],'CameraViewAngleMode','auto')
       set(gca,'YTick',[])
       %set(gca,'FontSize',0.5);
       %set(gca,'LineWidth',1.5);
       %eval(['print -dpng T:\users\rafa\Matlab\Tuberculosis\BOEgraph\090408--113303-11-G_profH' num2str(i) '.png']);
end
close
%figure(3)
%imagesc(imgBin)
%colormap(gray)
%axis off
%imwrite(imgBin*255,'T:\users\rafa\Matlab\Tuberculosis\BOEgraph\090408--111156-13-G_bin.png');
