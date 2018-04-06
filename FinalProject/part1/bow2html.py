f_in = open('html/html_output_keypoints.txt', 'r')
classes = ['airplanes', 'cars', 'faces', 'motorbikes']
f_out = None

for line in f_in:
    line_as_list = line.strip().split()

    if len(line_as_list) == 0 and f_out is not None :
        print('</tbody>\n</table>\n</body>\n</html>', file=f_out)
        f_out.close()
        f_out = None

    elif (line_as_list[0] == 'keypoints') or (line_as_list[0] == 'dense'):

        colorspace = line_as_list[1]
        if line_as_list[1] == 'rgb':
            line_as_list[1] = 'n_rgb'  # apparently rgb == RGB in file paths

        f_out = open('html/{}_{}_{}_{}.html'.format(*line_as_list), 'w')
        print('<!DOCTYPE html>\n<html lang="en">\n<head>\n<meta charset="utf-8">\n', file=f_out)
        print('<title>Image list prediction</title>\n<style type="text/css">\n', file=f_out)
        print('img {\nwidth:200px;\n}\n</style>\n</head>\n<body>\n\n', file=f_out)
        print('<h2>Florian Mohnert, Mario Giulianelli</h2>\n<h1>Settings</h1>\n<table>\n', file=f_out)

        if line_as_list[0] == 'keypoints': step_size = '-'
        else: step_size = '20 px'
        print('<tr><th>SIFT step size</th><td>{}</td></tr>'.format(step_size), file=f_out)

        print('<tr><th>SIFT block sizes</th><td>4 pixels</td></tr>', file=f_out)
        print('<tr><th>SIFT method</th><td>{}-SIFT</td></tr>'.format(colorspace), file=f_out)
        print('<tr><th>Vocabulary size</th><td>{} words</td></tr>'.format(line_as_list[2]), file=f_out)
        print('<tr><th>Vocabulary fraction</th><td>{}/{}</td></tr>'.format(line_as_list[2], line_as_list[2]), file=f_out)
        print('<tr><th>SVM training data</th><td>50 positive, 150 negative per class</td></tr>', file=f_out)
        print('<tr><th>SVM kernel type</th><td>{}</td></tr>'.format(line_as_list[3]), file=f_out)
        print('</table>', file=f_out)

    elif len(line_as_list) == 5:
        line_as_list = list(map(float, line_as_list))
        print('<h1>Prediction lists (MAP: {:5.3f})</h1>'.format(line_as_list[4]), file=f_out)
        print('<table>\n<thead>\n<tr>', file=f_out)
        print('<th>Airplanes (AP: {:5.3f})</th><th>Cars (AP: {:5.3f})</th><th>Faces (AP: {:5.3f})</th><th>Motorbikes (AP: {:5.3f})</th>'.format(*line_as_list[:-1]), file=f_out)
        print('</tr>\n</thead>\n<tbody>', file=f_out)

    elif len(line_as_list) == 4:
        line_as_list = list(map(int, line_as_list))
        print('<tr>', file=f_out, end='')
        for img_id in line_as_list:
            img_id -= 1  # because of matlab indexing
            [class_id, actual_img_id] = divmod(img_id, 50)
            # print(class_id, actual_img_id+1)
            print('<td><img src="../Caltech4/ImageData/{}_test/img{:03d}.jpg" /></td>'.format(classes[class_id], actual_img_id+1), file=f_out, end='')
        print('</tr>', file=f_out)

f_in.close()
