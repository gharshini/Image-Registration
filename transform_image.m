%% This function is to transform the moving image coordinates into the fixed image coordinates with the help of 
%transformation matrix which is calculated in the assignment3.m file 

function [transformed_moving_image] = transform_image(moving_image, transformation, fixed_image)
% This function transforms a moving_image by a 3x3 2D homogeneous transformation and
% writes the output to transformed_moving_image with the same dimensions as fixed_image

%if (size(transformation, 1) ~= 3) || (size(transformation, 2) ~= 3) || ~isequal(transformation(:,3), transpose([0 0 1]))
 if (size(transformation, 1) ~= 3) || (size(transformation, 2) ~= 3) || ~isequal(transformation(3,:), [0 0 1])
    error('The transformation must be a 3x3 2D homogeneous transformation matrix.');
end

transformed_moving_image = fixed_image;
inverse_transformation = inv(transformation);
source_x_max = size(moving_image, 2);
source_y_max = size(moving_image, 1);

% We iterate through the transformed_moving_image, copying the appropriate pixels from the moving_image
for y = 1 : size(transformed_moving_image, 1)
    for x = 1 : size(transformed_moving_image, 2)
        % Determine the coordinates of the source pixel that corresponds to the current destination coordinates
        destination_coordinates = [x; y; 1];
        source_coordinates = inverse_transformation * destination_coordinates;  % Since d = T*s, s = inv(T)*d
        
        % Copy a source pixel to the current pixel in the destination image using nearest neighbor interpolation
        source_x = round(source_coordinates(1));
        source_y = round(source_coordinates(2));
        if (source_x >= 1) && (source_x <= source_x_max) && (source_y >= 1) && (source_y <= source_y_max)
            transformed_moving_image(y,x,:) = moving_image(source_y,source_x,:);
        else  % The desired source pixel is outside the dimensions of the source image
            transformed_moving_image(y,x,:) = 0;  % Write a black pixel
        end
    end
end

end
