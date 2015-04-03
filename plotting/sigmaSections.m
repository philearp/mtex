classdef sigmaSections < ODFSections
  
  properties
    sigma
    sR
  end
  
  properties (Hidden=true)
    maxSigma
  end
    
  methods
    
    function oS = sigmaSections(CS1,CS2,varargin)
      
      oS = oS@ODFSections(CS1,CS2);
      
      % get fundamental plotting region
      [phi1,Phi,phi2] = getFundamentalRegion(CS1,CS2,varargin{:});
      oS.maxSigma = min(phi1,phi2);
      oS.sR = sphericalRegion('maxTheta',Phi,'maxRho',max(phi1,phi2));
      
      % get sections
      
      oS.sigma = linspace(0,phi2,7);
      oS.sigma(end) = [];
      oS.sigma = get_option(varargin,'sigma',oS.sigma);
      
    end
    
    function ori = makeGrid(oS,varargin)
      
      oS.plotGrid = plotS2Grid(oS.sR,varargin{:});
      oS.gridSize = (0:numel(oS.sigma)) * length(oS.plotGrid);
      phi1 = repmat(oS.plotGrid.rho,1,1,numel(oS.sigma));
      Phi = repmat(oS.plotGrid.theta,1,1,numel(oS.sigma));      
      sigma = repmat(reshape(oS.sigma,1,1,[]),[size(oS.plotGrid) 1]);
      
      ori = orientation('Euler',phi1,Phi,sigma - phi1,'ZYZ');
      
    end

    function n = numSections(oS)
      n = numel(oS.sigma);
    end
    
    function [S2Pos,secPos] = project(oS,ori)
    
      [e1,e2,e3] = Euler(ori,'ZYZ');

      sigma = mod(e1 + e3,oS.maxSigma); %#ok<*PROP>
            
      % this builds a list 
      bounds = sort(unique([oS.sigma - oS.tol,oS.sigma + oS.tol]));
      [~,secPos] = histc(sigma,bounds);
      secPos(iseven(secPos)) = -1;
      secPos = (secPos + 1)./2;
      
      S2Pos = vector3d('polar',e2,e1);

    end
        
    function h = plotSection(oS,ax,sec,v,data,varargin)
      
      % plot data
      h = plot(v,data{:},'TR',[int2str(oS.sigma(sec)./degree),'^\circ'],...
        'parent',ax,varargin{:},'doNotDraw');

    end
  end
end
