classdef NoiseEstimator < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        CroppedImageLabel               matlab.ui.control.Label
        ImageLabel                      matlab.ui.control.Label
        PDFGraphLabel                   matlab.ui.control.Label
        HistogramBarGraphLabel          matlab.ui.control.Label
        DistributionTypeEditField       matlab.ui.control.EditField
        DistributionTypeEditFieldLabel  matlab.ui.control.Label
        VarianceEditField               matlab.ui.control.NumericEditField
        VarianceEditFieldLabel          matlab.ui.control.Label
        StandardDeviationEditField      matlab.ui.control.NumericEditField
        StandardDeviationLabel          matlab.ui.control.Label
        MeanEditField                   matlab.ui.control.NumericEditField
        MeanEditFieldLabel              matlab.ui.control.Label
        HistogramPlotButton             matlab.ui.control.Button
        CropImageButton                 matlab.ui.control.Button
        ImageReadButton                 matlab.ui.control.Button
        NoiseTypeDropDown               matlab.ui.control.DropDown
        NoiseTypeDropDownLabel          matlab.ui.control.Label
        Image                           matlab.ui.control.UIAxes
        PDFAxes                         matlab.ui.control.UIAxes
        HistogramAxes                   matlab.ui.control.UIAxes
        CroppedImage                    matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        TypeOfNoise % Description
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ImageReadButton
        function ImageReadButtonPushed(app, event)
global ImageRead;
File = uigetfile({'*.jpg';'*.png';'*.gif*';'*.tif'},'Image Selector');

GrayIMG = imread(File);
if (strcmp(app.TypeOfNoise, 'Normal')==1)
    ImageRead = GrayIMG;
    imshow(ImageRead, 'parent', app.Image);
    
    
elseif (strcmp(app.TypeOfNoise, 'Guassian')==1)
    ImageRead = imnoise(GrayIMG,'Gaussian');
    imshow(ImageRead, 'parent', app.Image); 
    
    
elseif (strcmp(app.TypeOfNoise, 'Salt & Pepper')==1)
    ImageRead = imnoise(GrayIMG,'salt & pepper');
    imshow(ImageRead, 'parent', app.Image);
    
    
    
end
        end

        % Button pushed function: CropImageButton
        function CropImageButtonPushed(app, event)
global CroppedImage
global ImageRead


ImCropped = imcrop(ImageRead);

imwrite(ImCropped,'crop.jpg');

CroppedImage = imread('crop.jpg');
CroppedImage = rgb2gray(CroppedImage);

imshow(CroppedImage, 'parent', app.CroppedImage);
        end

        % Button pushed function: HistogramPlotButton
        function HistogramPlotButtonPushed(app, event)
global CroppedImage;


CroppedImage = double(imread('crop.jpg'));

HistPlot = imread('crop.jpg');

    HistogramBar = imhist(HistPlot);
    normalizedY = HistogramBar/sum(HistogramBar);
    x = 0:255;
    bar(app.HistogramAxes, x, normalizedY);
    
    
    Mean = mean2(HistPlot);
    app.MeanEditField.Value = Mean;
    
    StD  = std2(HistPlot);
    app.StandardDeviationEditField.Value = StD;
    
    Var = (StD)^2;
    app.VarianceEditField.Value = Var;
    
    PDF = (1./(StD*2*pi))*exp(-(x-Mean).^2/(2*StD^2));
    plot(app.PDFAxes, x, PDF, 'LineWidth', 2);
    
if (strcmp(app.TypeOfNoise, 'Normal')==1)
                app.DistributionTypeEditField.Value = 'Normal Distribution'
                
            elseif (strcmp(app.TypeOfNoise, 'Guassian')==1)
                app.DistributionTypeEditField.Value = 'Gaussian Distribution'
                
            elseif (strcmp(app.TypeOfNoise, 'Salt & Pepper')==1)
                app.DistributionTypeEditField.Value = 'Salt & pepper Distribution'
                
                
end
        end

        % Drop down opening function: NoiseTypeDropDown
        function NoiseTypeDropDownOpening(app, event)
            
        end

        % Value changed function: NoiseTypeDropDown
        function NoiseTypeDropDownValueChanged(app, event)
            app.TypeOfNoise = app.NoiseTypeDropDown.Value;
        end

        % Value changed function: DistributionTypeEditField
        function DistributionTypeEditFieldValueChanged(app, event)

            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.502 0.502 0.502];
            app.UIFigure.Position = [100 100 1128 658];
            app.UIFigure.Name = 'MATLAB App';

            % Create CroppedImage
            app.CroppedImage = uiaxes(app.UIFigure);
            app.CroppedImage.FontName = 'Arial';
            app.CroppedImage.XTick = [];
            app.CroppedImage.YTick = [];
            app.CroppedImage.FontSize = 12;
            app.CroppedImage.Position = [788 413 326 191];

            % Create HistogramAxes
            app.HistogramAxes = uiaxes(app.UIFigure);
            xlabel(app.HistogramAxes, 'Mean')
            ylabel(app.HistogramAxes, 'Normalized Y')
            zlabel(app.HistogramAxes, 'Z')
            app.HistogramAxes.Position = [412 14 343 334];

            % Create PDFAxes
            app.PDFAxes = uiaxes(app.UIFigure);
            xlabel(app.PDFAxes, 'x')
            ylabel(app.PDFAxes, 'f(x)')
            zlabel(app.PDFAxes, 'Z')
            app.PDFAxes.Position = [768 14 346 334];

            % Create Image
            app.Image = uiaxes(app.UIFigure);
            app.Image.FontName = 'Arial';
            app.Image.XTick = [];
            app.Image.YTick = [];
            app.Image.FontSize = 12;
            app.Image.Position = [1 413 326 191];

            % Create NoiseTypeDropDownLabel
            app.NoiseTypeDropDownLabel = uilabel(app.UIFigure);
            app.NoiseTypeDropDownLabel.BackgroundColor = [0.9294 0.6941 0.1255];
            app.NoiseTypeDropDownLabel.HorizontalAlignment = 'right';
            app.NoiseTypeDropDownLabel.FontSize = 30;
            app.NoiseTypeDropDownLabel.FontWeight = 'bold';
            app.NoiseTypeDropDownLabel.FontColor = [1 1 1];
            app.NoiseTypeDropDownLabel.Position = [342 592 163 36];
            app.NoiseTypeDropDownLabel.Text = 'Noise Type';

            % Create NoiseTypeDropDown
            app.NoiseTypeDropDown = uidropdown(app.UIFigure);
            app.NoiseTypeDropDown.Items = {'choose noise', 'Normal', 'Guassian', 'Salt & Pepper'};
            app.NoiseTypeDropDown.DropDownOpeningFcn = createCallbackFcn(app, @NoiseTypeDropDownOpening, true);
            app.NoiseTypeDropDown.ValueChangedFcn = createCallbackFcn(app, @NoiseTypeDropDownValueChanged, true);
            app.NoiseTypeDropDown.FontSize = 30;
            app.NoiseTypeDropDown.Position = [520 592 260 36];
            app.NoiseTypeDropDown.Value = 'choose noise';

            % Create ImageReadButton
            app.ImageReadButton = uibutton(app.UIFigure, 'push');
            app.ImageReadButton.ButtonPushedFcn = createCallbackFcn(app, @ImageReadButtonPushed, true);
            app.ImageReadButton.BackgroundColor = [0.302 0.7451 0.9333];
            app.ImageReadButton.FontSize = 15;
            app.ImageReadButton.FontWeight = 'bold';
            app.ImageReadButton.FontColor = [1 1 1];
            app.ImageReadButton.Position = [412 547 267 27];
            app.ImageReadButton.Text = 'Image Read';

            % Create CropImageButton
            app.CropImageButton = uibutton(app.UIFigure, 'push');
            app.CropImageButton.ButtonPushedFcn = createCallbackFcn(app, @CropImageButtonPushed, true);
            app.CropImageButton.BackgroundColor = [0.302 0.7451 0.9333];
            app.CropImageButton.FontSize = 15;
            app.CropImageButton.FontWeight = 'bold';
            app.CropImageButton.FontColor = [1 1 1];
            app.CropImageButton.Position = [412 509 267 27];
            app.CropImageButton.Text = 'Crop Image';

            % Create HistogramPlotButton
            app.HistogramPlotButton = uibutton(app.UIFigure, 'push');
            app.HistogramPlotButton.ButtonPushedFcn = createCallbackFcn(app, @HistogramPlotButtonPushed, true);
            app.HistogramPlotButton.BackgroundColor = [0.302 0.7451 0.9333];
            app.HistogramPlotButton.FontSize = 15;
            app.HistogramPlotButton.FontWeight = 'bold';
            app.HistogramPlotButton.FontColor = [1 1 1];
            app.HistogramPlotButton.Position = [412 470 267 30];
            app.HistogramPlotButton.Text = 'Histogram Plot';

            % Create MeanEditFieldLabel
            app.MeanEditFieldLabel = uilabel(app.UIFigure);
            app.MeanEditFieldLabel.BackgroundColor = [0.4667 0.6745 0.1882];
            app.MeanEditFieldLabel.HorizontalAlignment = 'center';
            app.MeanEditFieldLabel.FontName = 'Arial';
            app.MeanEditFieldLabel.FontSize = 30;
            app.MeanEditFieldLabel.FontWeight = 'bold';
            app.MeanEditFieldLabel.FontColor = [1 1 1];
            app.MeanEditFieldLabel.Position = [19 347 237 36];
            app.MeanEditFieldLabel.Text = 'Mean';

            % Create MeanEditField
            app.MeanEditField = uieditfield(app.UIFigure, 'numeric');
            app.MeanEditField.FontName = 'Arial';
            app.MeanEditField.FontSize = 30;
            app.MeanEditField.Position = [271 347 126 36];

            % Create StandardDeviationLabel
            app.StandardDeviationLabel = uilabel(app.UIFigure);
            app.StandardDeviationLabel.BackgroundColor = [0.4667 0.6745 0.1882];
            app.StandardDeviationLabel.HorizontalAlignment = 'right';
            app.StandardDeviationLabel.FontName = 'Arial';
            app.StandardDeviationLabel.FontSize = 25;
            app.StandardDeviationLabel.FontWeight = 'bold';
            app.StandardDeviationLabel.FontColor = [1 1 1];
            app.StandardDeviationLabel.Position = [19 278 235 31];
            app.StandardDeviationLabel.Text = 'Standard Deviation';

            % Create StandardDeviationEditField
            app.StandardDeviationEditField = uieditfield(app.UIFigure, 'numeric');
            app.StandardDeviationEditField.FontName = 'Arial';
            app.StandardDeviationEditField.FontSize = 30;
            app.StandardDeviationEditField.Position = [269 273 126 36];

            % Create VarianceEditFieldLabel
            app.VarianceEditFieldLabel = uilabel(app.UIFigure);
            app.VarianceEditFieldLabel.BackgroundColor = [0.4667 0.6745 0.1882];
            app.VarianceEditFieldLabel.HorizontalAlignment = 'center';
            app.VarianceEditFieldLabel.FontName = 'Arial';
            app.VarianceEditFieldLabel.FontSize = 30;
            app.VarianceEditFieldLabel.FontWeight = 'bold';
            app.VarianceEditFieldLabel.FontColor = [1 1 1];
            app.VarianceEditFieldLabel.Position = [21 208 235 36];
            app.VarianceEditFieldLabel.Text = 'Variance';

            % Create VarianceEditField
            app.VarianceEditField = uieditfield(app.UIFigure, 'numeric');
            app.VarianceEditField.FontName = 'Arial';
            app.VarianceEditField.FontSize = 30;
            app.VarianceEditField.Position = [271 208 126 36];

            % Create DistributionTypeEditFieldLabel
            app.DistributionTypeEditFieldLabel = uilabel(app.UIFigure);
            app.DistributionTypeEditFieldLabel.BackgroundColor = [0.149 0.149 0.149];
            app.DistributionTypeEditFieldLabel.HorizontalAlignment = 'right';
            app.DistributionTypeEditFieldLabel.FontName = 'Arial';
            app.DistributionTypeEditFieldLabel.FontSize = 20;
            app.DistributionTypeEditFieldLabel.FontWeight = 'bold';
            app.DistributionTypeEditFieldLabel.FontColor = [1 1 1];
            app.DistributionTypeEditFieldLabel.Position = [21 106 168 49];
            app.DistributionTypeEditFieldLabel.Text = 'Distribution Type';

            % Create DistributionTypeEditField
            app.DistributionTypeEditField = uieditfield(app.UIFigure, 'text');
            app.DistributionTypeEditField.ValueChangedFcn = createCallbackFcn(app, @DistributionTypeEditFieldValueChanged, true);
            app.DistributionTypeEditField.FontName = 'Arial';
            app.DistributionTypeEditField.FontSize = 15;
            app.DistributionTypeEditField.FontWeight = 'bold';
            app.DistributionTypeEditField.Position = [204 106 195 49];

            % Create HistogramBarGraphLabel
            app.HistogramBarGraphLabel = uilabel(app.UIFigure);
            app.HistogramBarGraphLabel.BackgroundColor = [1 0 0];
            app.HistogramBarGraphLabel.HorizontalAlignment = 'center';
            app.HistogramBarGraphLabel.FontSize = 25;
            app.HistogramBarGraphLabel.FontColor = [1 1 1];
            app.HistogramBarGraphLabel.Position = [452 368 294 31];
            app.HistogramBarGraphLabel.Text = 'Histogram Bar Graph';

            % Create PDFGraphLabel
            app.PDFGraphLabel = uilabel(app.UIFigure);
            app.PDFGraphLabel.BackgroundColor = [1 0 0];
            app.PDFGraphLabel.HorizontalAlignment = 'center';
            app.PDFGraphLabel.FontSize = 25;
            app.PDFGraphLabel.FontColor = [1 1 1];
            app.PDFGraphLabel.Position = [811 368 291 31];
            app.PDFGraphLabel.Text = 'PDF Graph';

            % Create ImageLabel
            app.ImageLabel = uilabel(app.UIFigure);
            app.ImageLabel.BackgroundColor = [1 1 0];
            app.ImageLabel.HorizontalAlignment = 'center';
            app.ImageLabel.FontSize = 25;
            app.ImageLabel.Position = [84 613 159 31];
            app.ImageLabel.Text = 'Image';

            % Create CroppedImageLabel
            app.CroppedImageLabel = uilabel(app.UIFigure);
            app.CroppedImageLabel.BackgroundColor = [1 1 0];
            app.CroppedImageLabel.HorizontalAlignment = 'center';
            app.CroppedImageLabel.FontSize = 25;
            app.CroppedImageLabel.Position = [868 613 178 31];
            app.CroppedImageLabel.Text = 'Cropped Image';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = NoiseEstimator

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
