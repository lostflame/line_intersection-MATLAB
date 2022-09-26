%==========================================================================
%
% line_intersection  Finds the intersection of two lines.
%
%   [x_int,y_int] = line_intersection(l1,l2)
%
% See also polyxpoly.
%
% Copyright © 2021 Tamas Kis
% Last Update: 2022-09-25
% Website: https://tamaskis.github.io
% Contact: tamas.a.kis@outlook.com
%
% TECHNICAL DOCUMENTATION:
% https://tamaskis.github.io/files/Intersection_of_Two_Lines.pdf
%
%--------------------------------------------------------------------------
%
% ------
% INPUT:
% ------
%   l1      - (1×1, 1×2, 1×3, or 1x4 double) vector defining line 1:
%               --> [x1]: vertical line form, x = x₁
%               --> [m1,b1]: slope-intercept form, y = m₁x + b₁
%               --> [x1,y1,m1]: point-slope form, y - y₁ = m₁(x - x₁)
%               --> [x1,y1,x2,y2]: two point form, {(x₁,y₁),(x₂,y₂)}
%   l2      - (1×1, 1×2, 1×3, or 1x4 double) vector defining line 2:
%               --> [x2]: vertical line form, x = x₂
%               --> [m2,b2]: slope-intercept form, y = m₂x + b₂
%               --> [x2,y2,m2]: point-slope form, y - y₂ = m₂(x - x₂)
%               --> [x3,y3,x4,y4]: two point form, {(x₃,y₃),(x₄,y₄)}
%
% -------
% OUTPUT:
% -------
%   x_int   - (1×1 double) x-coordinate of line intersection, xᵢₙₜ
%   y_int   - (1×1 double) y-coordinate of line intersection, yᵢₙₜ
%
%==========================================================================
function [x_int,y_int] = line_intersection(l1,l2)
    
    % converts both lines to point-slope form
    [x1,y1,m1] = get_point_slope(l1);
    [x2,y2,m2] = get_point_slope(l2);
    
    % --------------------------
    % Single intersection point.
    % --------------------------
    
    % case #1: line 1 nonvertical + line 2 nonvertical + not parallel
    if (~isnan(m1)) && (~isnan(m2)) && (m1 ~= m2)
        x_int = ((m1*x1-m2*x2)-(y1-y2))/(m1-m2);
        y_int = m1*(x_int-x1)+y1;
        
    % case #2: line 1 vertical + line 2 nonvertical
    elseif isnan(m1) && (~isnan(m2))
        x_int = x1;
        y_int = y2+m2*(x_int-x2);
        
    % case #3: line 1 nonvertical + line 2 vertical
    elseif ~isnan(m1) && isnan(m2)
        x_int = x2;
        y_int = y1+m1*(x_int-x1);
        
    % -----------------------------------------------
    % Infinite intersection points (collinear lines).
    % -----------------------------------------------
    
    % case #4: vertical + collinear
    elseif isnan(m1) && isnan(m2) && (x1 == x2)
        x_int = x1;
        y_int = NaN;
        
    % case #5: nonvertical + collinear
    elseif (m1 == m2) && ((y1-m1*x1) == (y2-m2*x2))
        x_int = NaN;
        y_int = NaN;
        
    % ------------------------------------------
    % Intersection at infinity (parallel lines).
    % ------------------------------------------
    
    % case #6: vertical + parallel lines
    elseif isnan(m1) && isnan(m2) && (x1 ~= x2)
        x_int = Inf;
        y_int = Inf;
        
    % case #7: nonvertical + parallel lines
    elseif (m1 == m2) && ((y1-m1*x1) ~= (y2-m2*x2))
        x_int = Inf;
        y_int = Inf;
        
    end
    
    % ---------
    % Warnings.
    % ---------
    
    % displays warning if two (non-vertical) lines are collinear (results
    % in (xᵢₙₜ,yᵢₙₜ) = (NaN,NaN))
    if isnan(x_int) && isnan(y_int)
        warning('The two lines are collinear.');
    end
    
    % displays warning if the two lines are parallel (results in 
    % (xᵢₙₜ,yᵢₙₜ) = (±∞,±∞))
    if abs(x_int) == Inf
        warning('The two lines are parallel.')
    end
    
    %======================================================================
    % get_point_slope  Converts a line of any form to point-slope form.
    %----------------------------------------------------------------------
    %
    % ------
    % INPUT:
    % ------
    %   line    - (1×1, 1×2, 1×3, or 1x4 double) vector defining the line:
    %               --> x1: vertical line form, x = x₁
    %               --> [m,b]: slope-intercept form, y = mx + b
    %               --> [x1,y1,m]: point-slope form, y - y₁ = m(x - x₁)
    %               --> [x1,y1,x2,y2]: two point form, {(x₁,y₁),(x₂,y₂)}
    %
    % -------
    % OUTPUT:
    % -------
    %   x1      - (1×1 double) x-coordinate of point on line, x₁
    %   y1      - (1×1 double) y-coordinate of point on line, y₁
    %   m       - (1×1 double) slope of line
    %
    % -----
    % NOTE:
    % -----
    %   --> If the line is vertical, the function returns x1 = x1, y1 = 0, 
    %       and m = NaN since a vertical line passes through the point
    %       (x₁,0) and has an undefined slope.
    %
    %======================================================================
    function [x1,y1,m] = get_point_slope(line)
        
        % input given in vertical line form
        if length(line) == 1
            x1 = line(1);
            y1 = 0;
            m = NaN;
            
        % input given in slope-intercept form
        elseif length(line) == 2
            x1 = 0;
            y1 = line(2);
            m = line(1);
            
        % input given in point-slope form
        elseif length(line) == 3
            x1 = line(1);
            y1 = line(2);
            m = line(3);
            
        % input given in two point form
        else
            m = (line(4)-line(2))/(line(3)-line(1));
            if abs(m) == Inf
                x1 = line(1);
                y1 = 0;
                m = NaN;
            else
                x1 = line(1);
                y1 = line(2);
            end
        end
        
    end
    
end