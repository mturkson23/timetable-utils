#!/usr/bin/python

from utils import make_query, execute_query
from enums import findparams
from xml.etree.ElementTree import Element, SubElement
from xml.etree import ElementTree
from xml.dom import minidom
from enums import get_CTTYPE
from time import time
from datetime import datetime
from pytz import timezone, utc


def truthy(var):
    if var == 1:
        return 'true'
    else:
        return 'false'


def get_default(meta, key):
    for i in range(1, len(meta)):
        if meta[i][0] == 'TIMETABLE_'+key.upper():
            return meta[i][1]


def get_sharingmatrix(sharing, roomid):
    matrices = []
    for i in range(1, len(sharing)):
        if sharing[i][1] == roomid:
            matrices.append(sharing[i])
    return matrices


def get_sharingpattern(patterns, matrixid):
    for i in range(1, len(patterns)):
        if patterns[i][0] == matrixid:
            return patterns[i]


def get_parent(children, parentid):
    cr = []
    for i in range(1, len(children)):
        if children[i][1] == parentid:
            cr.append(children[i])
    return cr


def get_studentoffering(offerings, stdid):
    so = []
    for i in range(1, len(offerings)):
        if offerings[i][1] == stdid:
            so.append(offerings[i])
            offerings.pop(i)
    return so


def prettify(elem):
    '''
    Return a pretty-printed XML string for the Element.
    '''
    rough_string = ElementTree.tostring(elem, 'utf-8')
    reparsed = minidom.parseString(rough_string)
    return reparsed.toprettyxml(indent="  ")


def search_defaults():
    findparams['tname'] = 'timetabledefault'
    findparams['xparams'] = ['NULL'] * 3
    findparams['columns'] = ['nam', 'val']
    q = make_query(findparams)
    return execute_query(q)


def search_sharingmatrices():
    findparams['tname'] = 'sharingmatrix'
    findparams['xparams'] = ['NULL'] * 5
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_sharingpatterns():
    findparams['tname'] = 'sharingpattern'
    findparams['xparams'] = ['NULL'] * 5
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_classrooms():
    findparams['tname'] = 'classroom'
    findparams['xparams'] = ['NULL'] * 5
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_classinstructors():
    findparams['tname'] = 'classinstructor'
    findparams['xparams'] = ['NULL'] * 4
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_classtimes():
    findparams['tname'] = 'classtime'
    findparams['xparams'] = ['NULL'] * 7
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_groupconstraint():
    findparams['tname'] = 'groupconstraint'
    findparams['xparams'] = ['NULL'] * 6
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_students():
    findparams['tname'] = 'student'
    findparams['xparams'] = ['NULL'] * 2
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_studentoffering(stdid):
    findparams['tname'] = 'studentoffering'
    findparams['xparams'] = ['NULL', stdid, 'NULL', 'NULL']
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_studentclass(stdid):
    findparams['tname'] = 'studentclass'
    findparams['xparams'] = ['NULL', stdid, 'NULL']
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_prohibitedclass(stdid):
    findparams['tname'] = 'prohibitedclass'
    findparams['xparams'] = ['NULL', stdid, 'NULL']
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_constraintclass(gconid):
    findparams['tname'] = 'constraintclass'
    findparams['xparams'] = ['NULL', gconid, 'NULL']
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def search_constraintparentclass(conid):
    findparams['tname'] = 'constraintparentclass'
    findparams['xparams'] = ['NULL', conid, 'NULL']
    findparams['columns'] = '*'
    q = make_query(findparams)
    return execute_query(q)


def write_xml():
    findparams['tname'] = 'room'
    findparams['xparams'] = ['NULL'] * 6
    findparams['columns'] = '*'
    room_find_query = make_query(findparams)
    meta = search_defaults()
    share = search_sharingmatrices()
    patterns = search_sharingpatterns()

    classrooms = search_classrooms()
    classinstructors = search_classinstructors()
    class_times = search_classtimes()
    grp_con = search_groupconstraint()
    students = search_students()
    # std_offerings = search_studentoffering()
    ts = time()
    date_zone = datetime.fromtimestamp(ts).replace(tzinfo=timezone(utc.zone))
    yr = date_zone.year
    created = date_zone.strftime('%a %b %d %H:%M:%S %Z %Y')
    timetable = Element(
                    'timetable', version=get_default(meta, 'version'),
                    initiative=get_default(meta, 'initiative'),
                    term=get_default(meta, 'term'),
                    created=created,
                    year=str(yr),
                    nrDays=get_default(meta, 'nrdays'),
                    slotsPerDay=get_default(meta, 'slotsperday'))
    rooms_res = execute_query(room_find_query)
    rooms = SubElement(timetable, 'rooms')
    room = list()
    # remember 0th index is where the count is placed
    for i in xrange(1, len(rooms_res)):
        tmp = Element(
                'room', id=str(rooms_res[i][0]),
                capacity=str(rooms_res[i][1]),
                location=str(rooms_res[i][2]),
                ignoreTooFar=truthy(rooms_res[i][3]),
                discouraged=truthy(rooms_res[i][4]),
                constraint=truthy(rooms_res[i][5]))
        # clean up
        if truthy(rooms_res[i][3]) is "false":
            tmp.attrib.pop('ignoreTooFar')
        if truthy(rooms_res[i][4]) is "false":
            tmp.attrib.pop('discouraged')
        room.append(tmp)
        shared = get_sharingmatrix(share, rooms_res[i][0])
        if shared != []:
            sharing = SubElement(tmp, 'sharing')
            # make pattern
            pat = get_sharingpattern(patterns, shared[0][2])
            pattern = Element('pattern', unit=str(pat[1]))
            pattern.text = pat[2]
            ffa = Element('freeForAll', value=pat[3])
            nav = Element('notAvailable', value=pat[4])

            share_matrix = [pattern, ffa, nav]
            # add sharing departments
            for i in xrange(len(shared)):
                dept = Element(
                        'department', value=str(shared[i][4]),
                        id=str(shared[i][3]))
                share_matrix.append(dept)
            # make sharing matrix
            sharing.extend(share_matrix)
    rooms.extend(room)
    # classes
    findparams['tname'] = 'class'
    findparams['xparams'] = ['NULL'] * 14
    findparams['columns'] = '*'
    class_find_query = make_query(findparams)
    classes_res = execute_query(class_find_query)
    classes = SubElement(timetable, 'classes')
    xclass = list()
    for i in xrange(1, len(classes_res)):
        classid = classes_res[i][0]
        tmp = Element(
                'class', id=str(classid),
                offering=str(classes_res[i][1]),
                config=str(classes_res[i][2]),
                subpart=str(classes_res[i][3]),
                parent=str(classes_res[i][4]),
                scheduler=str(classes_res[i][5]),
                department=str(classes_res[i][6]),
                committed=truthy(classes_res[i][7]),
                classLimit=str(classes_res[i][8]),
                minClassLimit=str(classes_res[i][9]),
                maxClassLimit=str(classes_res[i][10]),
                roomToLimitRatio=str(classes_res[i][11]),
                nrRooms=str(classes_res[i][12]),
                dates=str(classes_res[i][13]))
        # clean up
        if classes_res[i][4] is None:
            tmp.attrib.pop('parent')
        if classes_res[i][1] is None:
            tmp.attrib.pop('offering')
        if classes_res[i][2] is None:
            tmp.attrib.pop('config')
        if classes_res[i][3] is None:
            tmp.attrib.pop('subpart')
        if classes_res[i][5] is None:
            tmp.attrib.pop('scheduler')
        if classes_res[i][6] is None:
            tmp.attrib.pop('department')
        if classes_res[i][8] is None:
            tmp.attrib.pop('classLimit')
        if classes_res[i][9] is None:
            tmp.attrib.pop('minClassLimit')
        if classes_res[i][10] is None:
            tmp.attrib.pop('maxClassLimit')
        if classes_res[i][12] == 1:
            tmp.attrib.pop('nrRooms')
        if classes_res[i][11] == 1:
            tmp.attrib.pop('roomToLimitRatio')
        #
        # classrooms
        #
        classroom = get_parent(classrooms, classid)
        # class_attribs = list()
        if len(classroom) is not 0:
            for i in xrange(len(classroom)):
                cr_sol = truthy(classroom[i][3])
                cr_prf = str(classroom[i][4])
                c_room = SubElement(tmp, 'room', id=str(classroom[i][2]),
                                    pref=cr_prf,
                                    solution=cr_sol)
                if cr_sol == 'false':
                    c_room.attrib.pop('solution')
                if cr_prf == 'None':
                    c_room.attrib.pop('pref')
        #
        # instructors
        #
        class_inst = get_parent(classinstructors, classid)
        # ci_attribs = list()
        if len(class_inst) is not 0:
            for i in xrange(len(class_inst)):
                ci_sol = truthy(class_inst[i][3])
                ci_element = SubElement(
                                        tmp,
                                        'instructor', id=str(class_inst[i][2]),
                                        solution=ci_sol)
                if ci_sol is 'false':
                    ci_element.attrib.pop('solution')
                # ci_attribs.append(ci_element)
        #
        # class times
        #
        class_time = get_parent(class_times, classid)
        # ct_attribs = list()
        if len(class_time) is not 0:
            for i in xrange(len(class_time)):
                ct_sol = truthy(class_time[i][6])
                ct_element = SubElement(
                                        tmp,
                                        'time',
                                        days=str(class_time[i][2]),
                                        start=str(class_time[i][3]),
                                        length=str(class_time[i][4]),
                                        pref=str(class_time[i][5]),
                                        solution=ct_sol)
                if ct_sol == 'false':
                    ct_element.attrib.pop('solution')
                # ct_attribs.append(ct_element)
            xclass.append(tmp)
    classes.extend(xclass)
    #
    # group constraint
    #
    gc_element = SubElement(timetable, 'groupConstraints')
    # constraint = list()
    for i in xrange(1, len(grp_con)):
        gc_del = str(grp_con[i][5])
        gc_type = get_CTTYPE(grp_con[i][2])
        gc_limit = str(grp_con[i][4])
        constraint_id = str(grp_con[i][1])
        group_constraint_id = str(grp_con[i][0])
        con_element = SubElement(
                                gc_element,
                                'constraint',
                                id=constraint_id,
                                type=gc_type,
                                pref=str(grp_con[i][3]),
                                courseLimit=gc_limit,
                                delta=gc_del)
        if gc_del == 'None':
            con_element.attrib.pop('delta')
        if gc_limit == 'None':
            con_element.attrib.pop('courseLimit')
        if gc_type == 'None':
            con_element.attrib.pop('type')
        #
        # constraint parent class
        #
        parent_class = search_constraintparentclass(group_constraint_id)
        # pc_tags = list()
        if len(parent_class) is not 0:
            for i in xrange(1, len(parent_class)):
                cp_element = SubElement(con_element, 'parentClass',
                                        id=str(parent_class[i][2]))
                # pc_tags.append(cp_element)
        #
        # constraint class
        #
        con_class = search_constraintclass(group_constraint_id)
        # cc_tags = list()
        if len(con_class) is not 0:
            for i in xrange(1, len(con_class)):
                cc_element = SubElement(con_element, 'class',
                                        id=str(con_class[i][2]))
    #
    # students
    #
    students_tag = SubElement(timetable, 'students')
    # student = list()
    for i in xrange(1, len(students)):
        studentid = str(students[i][1])
        std_element = SubElement(
                                students_tag,
                                'student',
                                id=studentid)
        # student.append(std_element)
        #
        # student offering
        #
        std_off = search_studentoffering(studentid)
        # so_tags = list()
        if len(std_off) is not 0:
            for i in xrange(1, len(std_off)):
                so_element = SubElement(std_element, 'offering',
                                        id=str(std_off[i][2]),
                                        weight=str(std_off[i][3]))
                if str(std_off[i][3]) == 'None':
                    so_element.attrib.pop('weight')
                # so_tags.append(so_element)
        #
        # student class
        #
        std_class = search_studentclass(studentid)
        # sc_tags = list()
        if len(std_class) is not 0:
            for i in xrange(1, len(std_class)):
                sc_element = SubElement(std_element,
                                        'class',
                                        id=str(std_class[i][2]))
                # sc_tags.append(sc_element)
        #
        # student prohibited-class
        #
        prohib_class = search_prohibitedclass(studentid)
        # pc_tags = list()
        if len(prohib_class) is not 0:
            for i in xrange(1, len(prohib_class)):
                pc_element = SubElement(std_element,
                                        'prohibited-class',
                                        id=str(prohib_class[i][2]))
                # pc_tags.append(pc_element)
    # students_tag.extend(student)
    print prettify(timetable)
