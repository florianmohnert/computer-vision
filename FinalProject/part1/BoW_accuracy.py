from collections import defaultdict
import numpy as np

f_in = open('html/html_output_all.txt', 'r')
classes = ['airplanes', 'cars', 'faces', 'motorbikes']

accuracy_count = defaultdict(int)
count_50 = 0

for line in f_in:
    line_as_list = line.strip().split()

    if len(line_as_list) == 0:
        continue

    elif (line_as_list[0] == 'keypoints') or (line_as_list[0] == 'dense'):

        descriptor_type = line_as_list[0]
        colorspace = line_as_list[1]
        vocab_size = line_as_list[2]
        kernel = line_as_list[3]

    elif len(line_as_list) == 5:
        continue

    elif len(line_as_list) == 4:
        line_as_list = list(map(int, line_as_list))

        count_50 += 1
        if count_50 < 50:
            for k, img_id in enumerate(line_as_list):
                [class_id, _] = divmod(img_id, 50)

                if k == class_id:
                    accuracy_count[descriptor_type+colorspace+vocab_size+kernel] += 1
        elif count_50 == 200:
            count_50 = 0


settings, counts = [list(c) for c in zip(*accuracy_count.items())]
max_idx = np.argmax(counts)
best_setting = settings[max_idx]


print('Accuracy:', accuracy_count[best_setting] / 200, '  Setting:', best_setting)
print(accuracy_count[best_setting])
f_in.close()
