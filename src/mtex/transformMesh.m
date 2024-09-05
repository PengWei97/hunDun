function ebsdMesh = transformMesh(ebsdData, scaleFactor)
  % transformMesh Refine the mesh grid of an EBSD dataset.
  % This function interpolates an EBSD dataset to a finer mesh grid based
  % on a specified scaling factor. It computes a new grid of points within
  % the original data extend and performs interpolation at these points.
  %
  % Inputs:
  %   ebsdData - EBSD data set to be interpolated.
  %   scaleFactor - Factor to refine the mesh grid; greater than 1 for finer mesh.
  %
  % Output:
  %   ebsdMesh - Interpolated EBSD dataset with a refined mesh.
  %
  % Example:
  %   refinedEBSD = transformMesh(originalEBSD, 2);

  % Extract the boundary coordinates of the EBSD dataset
  [xmin, xmax, ymin, ymax] = ebsdData.extend;

  % Calculate the number of points for the refined mesh
  numPointsX = round((xmax - xmin) * scaleFactor);
  numPointsY = round((ymax - ymin) * scaleFactor);

  % Generate linearly spaced points for the new grid
  xNew = linspace(xmin, xmax, numPointsX);
  yNew = linspace(ymin, ymax, numPointsY);

  % Create a meshgrid of the new grid points
  [X, Y] = meshgrid(xNew, yNew);

  % Interpolate the EBSD data at new grid points
  ebsdMesh = interp(ebsdData, X(:), Y(:));
end
