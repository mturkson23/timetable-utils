# prepare params for sending
addparams = {
    'schema': 'timetable2',
    'faction': 'add',
}
findparams = {
    'schema': 'timetable2',
    'faction': 'find',
    'pageoffset': 'NULL',
    'pagelimit': 'NULL',
}
sharemat_params = {
    'schema': 'timetable2',
    'tname': 'xml_sharingmatrix',
    'faction': 'add',
}
XML_DATA = 'pu-spr07-ms.xml'
XML_OUTPUT = 'pu-spr07-ms-OUTPUT.xml'


def get_CTTYPEID(ct):
    switch = {
        "SAME_ROOM": '1',
        "SAME_TIME": '2',
        "SAME_START": '3',
        "SAME_DAYS": '4',
        "BTB_TIME": '5',
        "BTB": '6',
        "NHB_GTE(1)": '7',
        "NHB_LT(6)": '8',
        "NHB(1)": '9',
        "DIFF_TIME": '10',
        "SPREAD": '11',
        "BTB_DAY": '12',
        "CAN_SHARE_ROOM": '13',
        "SAME_INSTR": '14',
        "SAME_STUDENTS": '15',
        "MIN_GRUSE(10x1h)": '16',
        "MIN_GRUSE(5x2h)": '17',
        "MIN_GRUSE(3x3h)": '18',
        "MIN_GRUSE(2x5h)": '19',
        "MEET_WITH": '20',
        "PRECEDENCE": '21',
        "MIN_ROOM_USE": '22',
        "NDB_GT_1": '23',
        "CH_NOTOVERLAP": '24',
        "FOLLOWING_DAY": '25',
        "EVERY_OTHER_DAY": '26',
        "CLASS_LIMIT": '27',
    }
    return switch.get(ct, '0')


def get_CTTYPE(ct):
    switch = {
        '1': "SAME_ROOM",
        '2': "SAME_TIME",
        '3': "SAME_START",
        '4': "SAME_DAYS",
        '5': "BTB_TIME",
        '6': "BTB",
        '7': "NHB_GTE(1)",
        '8': "NHB_LT(6)",
        '9': "NHB(x)",
        '10': "DIFF_TIME",
        '11': "SPREAD",
        '12': "BTB_DAY",
        '13': "CAN_SHARE_ROOM",
        '14': "SAME_INSTR",
        '15': "SAME_STUDENTS",
        '16': "MIN_GRUSE(10x1h)",
        '17': "MIN_GRUSE(5x2h)",
        '18': "MIN_GRUSE(3x3h)",
        '19': "MIN_GRUSE(2x5h)",
        '20': "MEET_WITH",
        '21': "PRECEDENCE",
        '22': "MIN_ROOM_USE",
        '23': "NDB_GT_1",
        '24': "CH_NOTOVERLAP",
        '25': "FOLLOWING_DAY",
        '26': "EVERY_OTHER_DAY",
        '27': "CLASS_LIMIT",
    }
    return switch.get(ct, 'None')
