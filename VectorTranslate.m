classdef VectorTranslate
   methods(Static)
      function A = TranslateToNED(a, theta)
        R = VectorTranslate.GetRotationMatrix(theta);
        if (length(a) == 3)
            A = R*a;
        else
            A = VectorTranslate.TranslateX(a,R);
        end
      end
      function A = TranslateFromNED(a, theta)
        R = VectorTranslate.GetRotationMatrix(theta); %use transpose
        if (length(a) == 3)
            A = R'*a;
        else
            A = VectorTranslate.TranslateX(a,R');
        end
      end
      function X = TranslateX(x, R)
        X = zeros(6,1);
        X1 = [x(1);x(3);x(5)];
        X2 = [x(2);x(4);x(6)];
        X1 = R*X1;
        X2 = R*X2;
        X(1) = X1(1);
        X(2) = X2(1);
        X(3) = X1(2);
        X(4) = X2(2);
        X(5) = X1(3);
        X(6) = X2(3);
      end
      function R = GetRotationMatrix(theta)
          R = [cos(theta), -sin(theta), 0;
              sin(theta), cos(theta), 0;
              0, 0, 1];
      end
   end
end
