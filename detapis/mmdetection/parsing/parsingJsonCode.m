clc;
clear;
close all;
% Read all json file in folder
labels = dir('D:\parsingDataset\20220915_Linh_parsing\1_cycle_final\Test\json\*.json');
wanttoCut = char(34) + "item_ID" + char(34) + char(58) + char(34) + "ATO" + char(34) + char(44);
wanttoCut1 = char(34) + "item_ID" + char(34) + char(58) + char(34) + "TYO" + char(34) + char(44);
for num_image=1:size(labels,1)
    % Read custom json
    custom(num_image) = fopen(strcat(labels(num_image).folder,'/',labels(num_image).name),'r');
    A = fscanf(custom(num_image),'%s');
    A = erase(A, wanttoCut) ; 
    A = erase(A, wanttoCut1) ;
    fclose(custom(num_image));
    custom_struct{num_image,1} = jsondecode(A);
end

% Read standard
% json---------------------------------------------------------------------
coco_values = fopen('D:\parsingDataset\20220915_Linh_parsing\Roboflow_coco_train.json','r');
D = fscanf(coco_values,'%s');
fclose(coco_values);
coco_values_struct = jsondecode(D);

% licenses-----------------------------------------------------------------
new.licenses.name = "";
new.licenses.id = 1;
new.licenses.url = "";

% info---------------------------------------------------------------------
new.info.contributor = "ContilLab";
new.info.date_created = '';
new.info.description = '1.0';
new.info.url = '2022';
new.info.version = '';
new.info.year = '';

% categories---------------------------------------------------------------
new.categories = coco_values_struct.categories;
% images
image_id = 0;

for num_image=1:size(labels,1)
    new.images(num_image).id = image_id; % increment this id
    new.images(num_image).license = 1;
    new.images(num_image).file_name = strcat(labels(num_image).name(1:end-5),'.jpg');    
    %new.images(num_image).height = custom_struct{num_image}.Raw_Data_Info_.Resolution(2);
    %new.images(num_image).width = custom_struct{num_image}.Raw_Data_Info_.Resolution(1);     
    new.images(num_image).height = 1080;
    new.images(num_image).width = 1920;
    image_id = image_id + 1;    
end


% annotations
annotation_img_id = 1;

for num_image=1:size(labels,1)  

    fprintf('%s\n', custom_struct{num_image}.Learning_Data_Info_.Json_Data_ID)
    
    for j = 1:size(custom_struct{num_image}.Learning_Data_Info_.Annotations,1) 
        new.annotations(annotation_img_id).id = annotation_img_id - 1; 
        new.annotations(annotation_img_id).image_id = new.images(num_image).id;
        new.annotations(annotation_img_id).iscrowd = 0;
        
        tempValueSegmentation1 = [];
        tempValueSegmentation2 = [];
        tempValueSegmentation3 = [];
        tempValueSegmentation4 = [];
        tempValueSegmentation5 = [];
        tempValueSegmentation6 = [];
        tempValueSegmentation7 = [];
        tempValueSegmentation8 = [];
        tempValueSegmentation9 = [];
        tempValueSegmentation10 = [];
        tempValueSegmentation11 = [];
        tempValueSegmentation12 = [];
        tempValueSegmentation13 = [];
        tempValueSegmentation14 = [];
        tempValueSegmentation15 = [];
        tempValueSegmentation16 = [];
        tempValueSegmentation17 = [];
        tempValueSegmentation18 = [];
        tempValueSegmentation19 = [];
        tempValueSegmentation20 = [];
        tempValueSegmentation21 = [];
        tempValueSegmentation22 = [];
        tempValueSegmentation23 = [];
        tempValueSegmentation24 = [];
        tempValueSegmentation25 = [];
        tempValueSegmentation26 = [];
        tempValueSegmentation27 = [];
        tempValueSegmentation28 = [];
        tempValueSegmentation29 = [];
        tempValueSegmentation30 = [];
        tempValueSegmentation51 = [];
        tempValueSegmentation52 = [];

        temValueBoundingBox30 = [];  
        temValueBoundingBox31 = []; 
        temValueBoundingBox32 = []; 
        temValueBoundingBox33 = [];
        temValueBoundingBox34 = [];
        temValueBoundingBox35 = []; 
        temValueBoundingBox36 = [];
        temValueBoundingBox37 = [];  
        temValueBoundingBox38 = [];
        temValueBoundingBox39 = []; 
        temValueBoundingBox40 = [];
        temValueBoundingBox41 = [];  
        temValueBoundingBox42 = [];
        temValueBoundingBox43 = []; 
        temValueBoundingBox44 = [];
        temValueBoundingBox45 = []; 
        temValueBoundingBox46 = [];
        temValueBoundingBox47 = [];
        temValueBoundingBox48 = [];
        temValueBoundingBox49 = [];
        temValueBoundingBox50 = [];

        
       
        if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "WO-01"
            new.annotations(annotation_img_id).category_id = 1;  
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation1 = [tempValueSegmentation1;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation1;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
            %segmentation
         elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "WO-11"
            new.annotations(annotation_img_id).category_id = 2; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation2 = [tempValueSegmentation2;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation2;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;

        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "WO-17"
            new.annotations(annotation_img_id).category_id = 3; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation3 = [tempValueSegmentation3;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation3;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;

        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "WO-23"
            new.annotations(annotation_img_id).category_id = 4; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation4 = [tempValueSegmentation4;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation4;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;

        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-02"
            new.annotations(annotation_img_id).category_id = 5; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation5 = [tempValueSegmentation5;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation5;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-03"
            new.annotations(annotation_img_id).category_id = 6; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation6 = [tempValueSegmentation6;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation6;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-09"
            new.annotations(annotation_img_id).category_id = 7; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation7 = [tempValueSegmentation7;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation7;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-11"
            new.annotations(annotation_img_id).category_id = 8; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation8 = [tempValueSegmentation8;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation8;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-12"
            new.annotations(annotation_img_id).category_id = 9; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation9 = [tempValueSegmentation9;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation9;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-21"
            new.annotations(annotation_img_id).category_id = 10; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation10 = [tempValueSegmentation10;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation10;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-24"
            new.annotations(annotation_img_id).category_id = 11; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation11 = [tempValueSegmentation11;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation11;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-27"
            new.annotations(annotation_img_id).category_id = 12; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation12 = [tempValueSegmentation12;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation12;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-30"
            new.annotations(annotation_img_id).category_id = 13; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation13 = [tempValueSegmentation13;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation13;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-32"
            new.annotations(annotation_img_id).category_id = 14; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation14 = [tempValueSegmentation14;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation14;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-34"
            new.annotations(annotation_img_id).category_id = 15; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation15 = [tempValueSegmentation15;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation15;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-35"
            new.annotations(annotation_img_id).category_id = 16; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation16 = [tempValueSegmentation16;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation16;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-36"
            new.annotations(annotation_img_id).category_id = 17; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation17 = [tempValueSegmentation17;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation17;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-37"
            new.annotations(annotation_img_id).category_id = 18; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation18 = [tempValueSegmentation18;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation18;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-38"
            new.annotations(annotation_img_id).category_id = 19; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation19 = [tempValueSegmentation19;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation19;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-40"
            new.annotations(annotation_img_id).category_id = 20; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation20 = [tempValueSegmentation20;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation20;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-41"
            new.annotations(annotation_img_id).category_id = 21; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation21 = [tempValueSegmentation21;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation21;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-42"
            new.annotations(annotation_img_id).category_id = 22; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation22 = [tempValueSegmentation22;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation22;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-44"
            new.annotations(annotation_img_id).category_id = 23; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation23 = [tempValueSegmentation23;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation23;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-45"
            new.annotations(annotation_img_id).category_id = 24; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation24 = [tempValueSegmentation24;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation24;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-46"
            new.annotations(annotation_img_id).category_id = 25; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation25 = [tempValueSegmentation25;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation25;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-47"
            new.annotations(annotation_img_id).category_id = 26; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation26 = [tempValueSegmentation26;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation26;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "DO-01"
            new.annotations(annotation_img_id).category_id = 27; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation27 = [tempValueSegmentation27;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation27;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "DO-04"
            new.annotations(annotation_img_id).category_id = 28; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation28 = [tempValueSegmentation28;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation28;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "DO-06"
            new.annotations(annotation_img_id).category_id = 29; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation29 = [tempValueSegmentation29;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation29;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-01"
            new.annotations(annotation_img_id).category_id = 30; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox30 = [temValueBoundingBox30;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox30; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox30(1);temValueBoundingBox30(2);
                    (temValueBoundingBox30(1)+temValueBoundingBox30(3));temValueBoundingBox30(2);
                    (temValueBoundingBox30(1)+temValueBoundingBox30(3));(temValueBoundingBox30(2)+ temValueBoundingBox30(4));
                    temValueBoundingBox30(1);(temValueBoundingBox30(2)+ temValueBoundingBox30(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;


        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-11"
            new.annotations(annotation_img_id).category_id = 31; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox31 = [temValueBoundingBox31;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox31; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox31(1);temValueBoundingBox31(2);
                    (temValueBoundingBox31(1)+temValueBoundingBox31(3));temValueBoundingBox31(2);
                    (temValueBoundingBox31(1)+temValueBoundingBox31(3));(temValueBoundingBox31(2)+ temValueBoundingBox31(4));
                    temValueBoundingBox31(1);(temValueBoundingBox31(2)+ temValueBoundingBox31(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height; 

        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-12"
            new.annotations(annotation_img_id).category_id = 32; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox32 = [temValueBoundingBox32;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox32; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox32(1);temValueBoundingBox32(2);
                    (temValueBoundingBox32(1)+temValueBoundingBox32(3));temValueBoundingBox32(2);
                    (temValueBoundingBox32(1)+temValueBoundingBox32(3));(temValueBoundingBox32(2)+ temValueBoundingBox32(4));
                    temValueBoundingBox32(1);(temValueBoundingBox32(2)+ temValueBoundingBox32(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;

        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-13"
            new.annotations(annotation_img_id).category_id = 33; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox33 = [temValueBoundingBox33;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox33; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox33(1);temValueBoundingBox33(2);
                    (temValueBoundingBox33(1)+temValueBoundingBox33(3));temValueBoundingBox33(2);
                    (temValueBoundingBox33(1)+temValueBoundingBox33(3));(temValueBoundingBox33(2)+ temValueBoundingBox33(4));
                    temValueBoundingBox33(1);(temValueBoundingBox33(2)+ temValueBoundingBox33(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-14"
            new.annotations(annotation_img_id).category_id = 34; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox34 = [temValueBoundingBox34;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox34; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox34(1);temValueBoundingBox34(2);
                    (temValueBoundingBox34(1)+temValueBoundingBox34(3));temValueBoundingBox34(2);
                    (temValueBoundingBox34(1)+temValueBoundingBox34(3));(temValueBoundingBox34(2)+ temValueBoundingBox34(4));
                    temValueBoundingBox34(1);(temValueBoundingBox34(2)+ temValueBoundingBox34(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-32"
            new.annotations(annotation_img_id).category_id = 35; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox35 = [temValueBoundingBox35;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox35; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox35(1);temValueBoundingBox35(2);
                    (temValueBoundingBox35(1)+temValueBoundingBox35(3));temValueBoundingBox35(2);
                    (temValueBoundingBox35(1)+temValueBoundingBox35(3));(temValueBoundingBox35(2)+ temValueBoundingBox35(4));
                    temValueBoundingBox35(1);(temValueBoundingBox35(2)+ temValueBoundingBox35(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;    
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-33"
            new.annotations(annotation_img_id).category_id = 36; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox36 = [temValueBoundingBox36;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox36; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox36(1);temValueBoundingBox36(2);
                    (temValueBoundingBox36(1)+temValueBoundingBox36(3));temValueBoundingBox36(2);
                    (temValueBoundingBox36(1)+temValueBoundingBox36(3));(temValueBoundingBox36(2)+ temValueBoundingBox36(4));
                    temValueBoundingBox36(1);(temValueBoundingBox36(2)+ temValueBoundingBox36(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;    
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-35"
            new.annotations(annotation_img_id).category_id = 37; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox37 = [temValueBoundingBox37;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox37; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox37(1);temValueBoundingBox37(2);
                    (temValueBoundingBox37(1)+temValueBoundingBox37(3));temValueBoundingBox37(2);
                    (temValueBoundingBox37(1)+temValueBoundingBox37(3));(temValueBoundingBox37(2)+ temValueBoundingBox37(4));
                    temValueBoundingBox37(1);(temValueBoundingBox37(2)+ temValueBoundingBox37(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-37"
            new.annotations(annotation_img_id).category_id = 38; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox38 = [temValueBoundingBox38;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox38; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox38(1);temValueBoundingBox38(2);
                    (temValueBoundingBox38(1)+temValueBoundingBox38(3));temValueBoundingBox38(2);
                    (temValueBoundingBox38(1)+temValueBoundingBox38(3));(temValueBoundingBox38(2)+ temValueBoundingBox38(4));
                    temValueBoundingBox38(1);(temValueBoundingBox38(2)+ temValueBoundingBox38(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "Y-44"
            new.annotations(annotation_img_id).category_id = 39; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox39 = [temValueBoundingBox39;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox39; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox39(1);temValueBoundingBox39(2);
                    (temValueBoundingBox39(1)+temValueBoundingBox39(3));temValueBoundingBox39(2);
                    (temValueBoundingBox39(1)+temValueBoundingBox39(3));(temValueBoundingBox39(2)+ temValueBoundingBox39(4));
                    temValueBoundingBox39(1);(temValueBoundingBox39(2)+ temValueBoundingBox39(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "N-11"
            new.annotations(annotation_img_id).category_id = 40; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox40 = [temValueBoundingBox40;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox40; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox40(1);temValueBoundingBox40(2);
                    (temValueBoundingBox40(1)+temValueBoundingBox40(3));temValueBoundingBox40(2);
                    (temValueBoundingBox40(1)+temValueBoundingBox40(3));(temValueBoundingBox40(2)+ temValueBoundingBox40(4));
                    temValueBoundingBox40(1);(temValueBoundingBox40(2)+ temValueBoundingBox40(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "N-12"
            new.annotations(annotation_img_id).category_id = 41; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox41 = [temValueBoundingBox41;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox41; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox41(1);temValueBoundingBox41(2);
                    (temValueBoundingBox41(1)+temValueBoundingBox41(3));temValueBoundingBox41(2);
                    (temValueBoundingBox41(1)+temValueBoundingBox41(3));(temValueBoundingBox41(2)+ temValueBoundingBox41(4));
                    temValueBoundingBox41(1);(temValueBoundingBox41(2)+ temValueBoundingBox41(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "N-13"
            new.annotations(annotation_img_id).category_id = 42; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox42 = [temValueBoundingBox42;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox42; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox42(1);temValueBoundingBox42(2);
                    (temValueBoundingBox42(1)+temValueBoundingBox42(3));temValueBoundingBox42(2);
                    (temValueBoundingBox42(1)+temValueBoundingBox42(3));(temValueBoundingBox42(2)+ temValueBoundingBox42(4));
                    temValueBoundingBox42(1);(temValueBoundingBox42(2)+ temValueBoundingBox42(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "N-28"
            new.annotations(annotation_img_id).category_id = 43; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox43 = [temValueBoundingBox43;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox43; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox43(1);temValueBoundingBox43(2);
                    (temValueBoundingBox43(1)+temValueBoundingBox43(3));temValueBoundingBox43(2);
                    (temValueBoundingBox43(1)+temValueBoundingBox43(3));(temValueBoundingBox43(2)+ temValueBoundingBox43(4));
                    temValueBoundingBox43(1);(temValueBoundingBox43(2)+ temValueBoundingBox43(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "N-32"
            new.annotations(annotation_img_id).category_id = 44; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox44 = [temValueBoundingBox44;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox44; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox44(1);temValueBoundingBox44(2);
                    (temValueBoundingBox44(1)+temValueBoundingBox44(3));temValueBoundingBox44(2);
                    (temValueBoundingBox44(1)+temValueBoundingBox44(3));(temValueBoundingBox44(2)+ temValueBoundingBox44(4));
                    temValueBoundingBox44(1);(temValueBoundingBox44(2)+ temValueBoundingBox44(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "N-33"
            new.annotations(annotation_img_id).category_id = 45; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox45 = [temValueBoundingBox45;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox45; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox45(1);temValueBoundingBox45(2);
                    (temValueBoundingBox45(1)+temValueBoundingBox45(3));temValueBoundingBox45(2);
                    (temValueBoundingBox45(1)+temValueBoundingBox45(3));(temValueBoundingBox45(2)+ temValueBoundingBox45(4));
                    temValueBoundingBox45(1);(temValueBoundingBox45(2)+ temValueBoundingBox45(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "N-34"
            new.annotations(annotation_img_id).category_id = 46; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox46 = [temValueBoundingBox46;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox46; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox46(1);temValueBoundingBox46(2);
                    (temValueBoundingBox46(1)+temValueBoundingBox46(3));temValueBoundingBox46(2);
                    (temValueBoundingBox46(1)+temValueBoundingBox46(3));(temValueBoundingBox46(2)+ temValueBoundingBox46(4));
                    temValueBoundingBox46(1);(temValueBoundingBox46(2)+ temValueBoundingBox46(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "N-37"
            new.annotations(annotation_img_id).category_id = 47; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox47 = [temValueBoundingBox47;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox47; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox47(1);temValueBoundingBox47(2);
                    (temValueBoundingBox47(1)+temValueBoundingBox47(3));temValueBoundingBox47(2);
                    (temValueBoundingBox47(1)+temValueBoundingBox47(3));(temValueBoundingBox47(2)+ temValueBoundingBox47(4));
                    temValueBoundingBox47(1);(temValueBoundingBox47(2)+ temValueBoundingBox47(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;

        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "N-38"
            new.annotations(annotation_img_id).category_id = 48; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox48 = [temValueBoundingBox48;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox48; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox48(1);temValueBoundingBox48(2);
                    (temValueBoundingBox48(1)+temValueBoundingBox48(3));temValueBoundingBox48(2);
                    (temValueBoundingBox48(1)+temValueBoundingBox48(3));(temValueBoundingBox48(2)+ temValueBoundingBox48(4));
                    temValueBoundingBox48(1);(temValueBoundingBox48(2)+ temValueBoundingBox48(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;

        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "C-02"
            new.annotations(annotation_img_id).category_id = 49; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox49 = [temValueBoundingBox49;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox49; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox49(1);temValueBoundingBox49(2);
                    (temValueBoundingBox49(1)+temValueBoundingBox49(3));temValueBoundingBox49(2);
                    (temValueBoundingBox49(1)+temValueBoundingBox49(3));(temValueBoundingBox49(2)+ temValueBoundingBox49(4));
                    temValueBoundingBox49(1);(temValueBoundingBox49(2)+ temValueBoundingBox49(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;

        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "C-04"
            new.annotations(annotation_img_id).category_id = 50; 
            %bbox
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "bbox"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1)        
                    key_x_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i);
                    key_y_bbx = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1);            
                    temValueBoundingBox50 = [temValueBoundingBox50;key_x_bbx;key_y_bbx];
                    
                end
                new.annotations(annotation_img_id).bbox = temValueBoundingBox50; 
                new.annotations(annotation_img_id).segmentation = {[
                     temValueBoundingBox50(1);temValueBoundingBox50(2);
                    (temValueBoundingBox50(1)+temValueBoundingBox50(3));temValueBoundingBox50(2);
                    (temValueBoundingBox50(1)+temValueBoundingBox50(3));(temValueBoundingBox50(2)+ temValueBoundingBox50(4));
                    temValueBoundingBox50(1);(temValueBoundingBox50(2)+ temValueBoundingBox50(4))]};
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [0,0,0,0];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;    
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "WO-07"
            new.annotations(annotation_img_id).category_id = 51; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation51 = [tempValueSegmentation51;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation51;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
        elseif custom_struct{num_image}.Learning_Data_Info_.Annotations(j).class_ID == "SO-23"
            new.annotations(annotation_img_id).category_id = 52; 
            ymax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            ymin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
            xmax = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1); 
            xmin = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
            if custom_struct{num_image}.Learning_Data_Info_.Annotations(j).type == "polygon"
                for i=1:2:size(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value,1) 
                    firstValueX = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(1);
                    firstValueY = custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(2);
                    key_x = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i));
                    key_y = abs(custom_struct{num_image}.Learning_Data_Info_.Annotations(j).value(i+1));                    
                    tempValueSegmentation52 = [tempValueSegmentation52;key_x;key_y];
                    
                    if key_x >= xmax
                        xmax = key_x;
                    end
                    if key_x <= xmin
                        xmin = key_x;
                    end
                    if key_y >= ymax
                        ymax = key_y;
                    end
                    if key_y <= ymin
                        ymin = key_y;
                    end

                end
                new.annotations(annotation_img_id).segmentation = {[tempValueSegmentation52;firstValueX;firstValueY]};
                new.annotations(annotation_img_id).bbox = [xmin;ymin;(xmax-xmin);(ymax-ymin)];                 
                                
            else
                new.annotations(annotation_img_id).bbox = [0;0;0;0];
                new.annotations(annotation_img_id).segmentation = [];
            end
            new.annotations(annotation_img_id).area = new.annotations(annotation_img_id).bbox(3)*new.annotations(annotation_img_id).bbox(4); % width*height;
        
            
           
        end        
        
        annotation_img_id = annotation_img_id + 1;     
        
    end     
    %new.annotations(num_image).category_id = 1;
  
end

a = jsonencode(new);
fileID = fopen('D:\parsingDataset\20220915_Linh_parsing\ContilTest.json','w');
fwrite(fileID,a);
fclose(fileID);




