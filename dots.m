function [  ] = dots(figureNumber)
	f = [];
	ax = [];
	scale = [];
	player = [];
	board = [];
	col = [0.9290    0.6940    0.1250; 0    0.4470    0.7410];
	blueWins =[];
	orangeWins = [];
	blueScore = [];
	orangeScore = [];
	
	if(nargin<1)
		figureNumber = 1;
	end
	figureSetup(figureNumber);
	gameSetup();
	
	
	function [] = rescale(~,~)
		% Get new height and width of the figure
		h = f.Position(4); 
		w = f.Position(3);
		if(h/w<500/500) % determine if limited by height or width (check aspect ratio)
			s = h;
		else
			s = w*500/500;
		end
		ax.Position = [(w-s*6/7)/2 (h-s)/2, s*6/7 s];
		
		c = ax.Children;
		for i=1:length(c)
			c(i).MarkerSize = c(i).MarkerSize*s/scale;
			c(i).LineWidth = c(i).LineWidth*s/scale;
		end
		
		orangeWins.Position(3:4) = orangeWins.Position(3:4)*s/scale;
		orangeWins.Position(1:2) = [ax.Position(1)+(ax.Position(3)-orangeWins.Position(3))/2 ax.Position(2)+(ax.Position(4)-orangeWins.Position(4))/2];
		orangeWins.FontSize = orangeWins.FontSize*s/scale;
		
		blueWins.Position(3:4) = blueWins.Position(3:4)*s/scale;
		blueWins.Position(1:2) = [ax.Position(1)+(ax.Position(3)-blueWins.Position(3))/2 ax.Position(2)+(ax.Position(4)-blueWins.Position(4))/2];
		blueWins.FontSize = blueWins.FontSize*s/scale;
		
		orangeScore.Position(3:4) = orangeScore.Position(3:4)*s/scale;
		blueScore.Position(3:4) = blueScore.Position(3:4)*s/scale;
		
		orangeScore.Position(1:2) = [ax.Position(1)+(ax.Position(3)-(blueScore.Position(3)*2+10*s/500))/2+50*s/500 ax.Position(2)+(ax.Position(4)-orangeScore.Position(4))/2-(orangeScore.Position(4)+5*s/500)];
		blueScore.Position(1:2) = [ax.Position(1)+(ax.Position(3)-(blueScore.Position(3)*2+10*s/500))/2 ax.Position(2)+(ax.Position(4)-orangeScore.Position(4))/2-(orangeScore.Position(4)+5*s/500)];
		orangeScore.FontSize = orangeScore.FontSize*s/scale;
		blueScore.FontSize = blueScore.FontSize*s/scale;
		
		scale = s;
	end
	
	function [] = mouseClick(~,~)
		if( nnz(board)==97+42 ) % don't bother if board is full
			return
		end
		m = f.CurrentPoint;
		m = m - ax.Position(1:2);
		
		mx = m(1)/ax.Position(3)*7-0.5;
		my = 7.5-m(2)/ax.Position(4)*8;
		y_int = [my+mx, my-mx];
		a = -6:13;
		b = find(y_int(1)<a,1);
		c = find(y_int(2)<a,1);
		y = b+c-14;
		x = b-c+1;
		
		if(isempty(x) || isempty(y) || x<1 || x> 13 || y<1 || y>15 || board(y,x)~=0)
			return
		end
		
		board(y,x) = player;
		drawline(x,y);
		s = squareCheck(x,y);
		
		if(~s)
			player = -player;
		elseif( nnz(board)==97+42 ) % all lines drawn
			score1 = sum(sum(board==2));
			score_1 = sum(sum(board==-2));
			blueScore.String = num2str(score1);
			orangeScore.String = num2str(score_1);
			blueScore.Visible = 'on';
			orangeScore.Visible = 'on';
			
			if( score1>score_1)
				blueWins.Visible = 'on';
			else
				orangeWins.Visible = 'on';
			end
		end
	end
	
	function [] = drawline(x,y)
		if(mod(x,2)==0)
			line(x/2+[0 1], y/2+[0.5 0.5],'LineWidth',4*scale/500,'Color', col(player*0.5+1.5,:))
		else
			line(x/2+[0.5 0.5], y/2+[0 1],'LineWidth',4*scale/500,'Color', col(player*0.5+1.5,:))
		end
	end

	function [s] = squareCheck(x,y)
		px = [-0.4 -0.4 0.4 0.4];
		py = [-0.4 0.4 0.4 -0.4];
		s = false;
		if(mod(x,2)==0) % horizontal line
			if( y>1 && board(y-1,x-1)~=0 && board(y-2,x)~=0 && board(y-1,x+1)~=0)
				s = true;
				patch(x/2+0.5+px,y/2+py,col(player*0.5+1.5,:),'EdgeColor','none');
				board(y-1,x) = 2*player;
			end
			if( y<15 && board(y+1,x-1)~=0 && board(y+2,x)~=0 && board(y+1,x+1)~=0)
				s = true;
				patch(x/2+0.5+px,y/2+1+py,col(player*0.5+1.5,:),'EdgeColor','none');
				board(y+1,x) = 2*player;
			end
		else % vertical line
			if( x>1 && board(y-1,x-1)~=0 && board(y,x-2)~=0 && board(y+1,x-1)~=0)
				s = true;
				patch(x/2+px,y/2+0.5+py,col(player*0.5+1.5,:),'EdgeColor','none');
				board(y,x-1) = 2*player;
			end
			if( x<13 && board(y-1,x+1)~=0 && board(y,x+2)~=0 && board(y+1,x+1)~=0)
				s = true;
				patch(x/2+1+px,y/2+0.5+py,col(player*0.5+1.5,:),'EdgeColor','none');
				board(y,x+1) = 2*player;
			end
		end
	end

	function [] = gameSetup(~,~)
		cla
		blueScore.Visible = 'off';
		orangeScore.Visible = 'off';
		blueWins.Visible = 'off';
		orangeWins.Visible = 'off';
		[x,y] = meshgrid(1:7,1:8);
		x = reshape(x,[1,56]);
		y = reshape(y,[1,56]);
		plot(x,y,'o','MarkerFaceColor',[0 0 0],'MarkerEdgeColor','none','MarkerSize',7*scale/500)
		axis([0.5 7.5, 0.5 8.5])
		
		player = 1;
		board = zeros(15,13);
	end
	
	function [] = figureSetup(fignum)
		f = figure(fignum);
		clf
		f.SizeChangedFcn = ' ';
		f.MenuBar = 'none';
		f.Name = 'Dots';
		f.NumberTitle = 'off';

		s = get(0,'ScreenSize');
		h = 500; % equal to scale
		scale = h;
		f.Position = [(s(3)-h)/2 (s(4)-h)/2, h h];

		f.WindowButtonUpFcn = @mouseClick;
		f.SizeChangedFcn = @rescale;
		f.Resize = 'on';

		ax = axes('Parent',f);
		cla
		ax.Units = 'pixels';
		ax.Position = [h/14 0, h*6/7 h];
		ax.XTick = [];
		ax.YTick = [];
		ax.Box = 'on';
		ax.YDir = 'reverse';
		axis equal
		hold on
		ax.Color = f.Color;
		
		blueWins = uicontrol(f,'Style','pushbutton',...
			'String','Blue Wins',...
			'FontSize',20,...
			'ForegroundColor',col(2,:),...
			'Visible','off',...
			'Units','pixels',...
			'Callback',@gameSetup,...
			'Position',[ax.Position(1)+(ax.Position(3)-140)/2 ax.Position(2)+(ax.Position(4)-35)/2, 140 35]);
		
		orangeWins = uicontrol(f,'Style','pushbutton',...
			'String','Orange Wins',...
			'FontSize',20,...
			'ForegroundColor',col(1,:),...
			'Visible','off',...
			'Callback',@gameSetup,...
			'Units','pixels',...
			'Position',[ax.Position(1)+(ax.Position(3)-180)/2 ax.Position(2)+(ax.Position(4)-35)/2, 165 35]);
		
		blueScore = uicontrol(f,'Style','text',...
			'String','42',...
			'FontSize',20,...
			'ForegroundColor',col(2,:),...
			'Visible','off',...
			'Units','pixels',...
			'Position',[ax.Position(1)+(ax.Position(3)-90)/2 ax.Position(2)+(ax.Position(4)-35)/2-40, 40 35]);
		
		orangeScore = uicontrol(f,'Style','text',...
			'String','42',...
			'FontSize',20,...
			'ForegroundColor',col(1,:),...
			'Visible','off',...
			'Units','pixels',...
			'Position',[ax.Position(1)+(ax.Position(3)-90)/2+50 ax.Position(2)+(ax.Position(4)-35)/2-40, 40 35]);
	end
end

% 7 squares tall, 6 wide
% 8 dots tall, 7 dots wide