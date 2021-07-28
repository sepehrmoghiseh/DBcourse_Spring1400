import mysql.connector

flag = 1
while flag == 1:
    inputt = input(
        "welcome to Sepehr's dbms! enter a number : \n 1. connect to database & write query \n 2.guide \n3.exit\n")
    if int(inputt) == 1:
        connection = mysql.connector.connect(host='127.10.0.1',
                                             database='canary',
                                             user='root',
                                             password='amq690amq690')
        cursor = connection.cursor()
        flag2 = 1
        while flag2 == 1:
            query = input("write an query ,see the guide for help! back with 0\n")
            splited = query.split()
            if splited[0] == "0":
                flag2 = 2
            elif splited[0] == "register":
                query2 = []
                query2.insert(0, splited[1])
                query2.insert(1, splited[2])
                query2.insert(2, splited[3])
                query2.insert(3, splited[4])
                query2.insert(4, splited[5])
                biography = " ".join(splited[6::1])
                query2.insert(5, biography)
                cursor.callproc(splited[0], query2)
                connection.commit()
            elif splited[0] == "login":
                query2 = []
                query2.insert(0, splited[1])
                query2.insert(1, splited[2])
                cursor.callproc(splited[0], query2)
                connection.commit()
            elif splited[0] == "us_lg":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("user_logins", query2)
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "send_ava":
                query2 = []
                content = " ".join(splited[1::1])
                query2.insert(0, content)
                cursor.callproc(splited[0], query2)
                connection.commit()
            elif splited[0] == "find_ava":
                cursor.callproc("find_personal_ava")
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "follw":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("follow_action", query2)
                connection.commit()
            elif splited[0] == "unfollow":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("delete_following", query2)
                connection.commit()
            elif splited[0] == "block":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("block", query2)
                connection.commit()
            elif splited[0] == "unblock":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("delete_blockings", query2)
                connection.commit()
            elif splited[0] == "follow_ava":
                cursor.callproc("find_followings_ava")
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "find_someone_ava":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("find_someone_ava", query2)
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "comment":
                query2 = []
                content = " ".join(splited[2::1])
                query2.insert(0, content)
                query2.insert(1, splited[1])
                cursor.callproc("comment_action", query2)
                connection.commit()
            elif splited[0] == "find_ava_com":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("find_comments_ava", query2)
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "hashtag":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("find_hashtag_ava", query2)
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "like":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("like_action", query2)
                connection.commit()

            elif splited[0] == "count":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("likes_count", query2)
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "who_like":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("who_likes", query2)
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "trend":
                cursor.callproc("trend_ava")
                name=cursor.column_names
                print(name)
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "send_ms":
                query2 = []
                query2.insert(0, splited[1])
                query2.insert(1, splited[2])
                if int(splited[1]) == 0:
                    content = " ".join(splited[3::1])
                    query2.insert(2, content)
                    query2.insert(3, 0)
                elif int(splited[1]) == 1:
                    query2.insert(2, "none")
                    query2.insert(3, splited[3])
                cursor.callproc("send_pm", query2)
                connection.commit()
            elif splited[0] == "who_messaged":
                cursor.callproc("find_who_message")
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)
            elif splited[0] == "find_message_someone":
                query2 = []
                query2.insert(0, splited[1])
                cursor.callproc("find_someone_messages", query2)
                for result in cursor.stored_results():
                    row = result.fetchall()

                for row in row:
                    print(row)

    elif int(inputt) == 2:
        print("1.register: register [firstname] [lastname] [username] [password] [birthday] [biography]\n " +
              "2.login : login [username] [password]\n" +
              "3.user_login : us_lg [username] \n" +
              "4.send an ava : send_ava [content]\n" +
              "5.find personal the avas :find_ava\n" +
              "6.follow some one : follw [username]\n" +
              "7.unfollow: unfollow [username]\n" +
              "8.blocking : block [username]\n" +
              "9.unblock: unblock [username]\n" +
              "10.find followers avas:follow_ava\n" +
              "11.find someone ava : find_someone_ava [username]\n" +
              "12.commenting :comment [ava_id] [content]\n" +
              "13.find comments of an ava : find_ava_com [ava_id]\n" +
              "14.find ava of an hashtag: hashtag [hashtag with #]\n" +
              "15.like an ava : like [ava_id]\n" +
              "16.count like :count [ava_ida]\n" +
              "17.who like an ava : who_like [ava_id]\n" +
              "18.trending : trend\n" +
              "19.send message: send_ms [type 0 for pm 1 for ava] [username] [ava_id or pm]\n" +
              "20.who messaged you : who_messaged \n" +
              "21.find messages from someone : find_message_someone [username]\n")
    elif int(inputt) == 3:
        exit(0)
