<?
    $db = new SafeMySQL(array('user' => 'h133006_root', 'pass' => 'ADminium-12', 'db' => 'h133006_db', 'charset' => 'utf8'));
   
    $data = $db->getRow('SELECT * FROM task WHERE id=?i',$this->taskid);

    $user = $db->getRow('SELECT * FROM user WHERE id=?i',$data["userid"]);
    $username = $user["login"];

    $date = date("d.m.Y", $data["date"]); 

    $status = $data["status"];
    if($data["status"] == "released") {
        $statuslabel = '<span class="uk-label uk-label-success">Опубликован</span>';
    } else if($data["status"] == "moderating") {
        $statuslabel = '<span class="uk-label uk-label-warning">На модерации</span>';
    } else if($data["status"] == "remoderating") {
        $statuslabel = '<span class="uk-label uk-label-warning">На ремодерации</span>';
    } else if($data["status"] == "blocked") {
        $statuslabel = '<span class="uk-label uk-label-danger">отклонен</span>';
    } 

    $answers = "";

    $tags = unserialize($data["tags"]);


    foreach (unserialize($data["answers"]) as $answer) {
        if($answer[0] == 1) {
            $chlabel = '<span class="uk-label label-adjust uk-label-success">Правильно</span>';
        } else {
            $chlabel = '<span class="uk-label label-adjust uk-label-danger">Неправильно</span>';
        }
        $answers = $answers.'<tr><td class="uk-table-shrink">'.$chlabel.'</td><td class="uk-width-1-1">'.$answer[1].'</td></tr>';
    }

    $comments = $db->getAll('SELECT * FROM comment WHERE taskid=?i',$this->taskid);

    $counter = 0;
                                                    foreach (unserialize($data["answers"]) as $answer) {
                                                        if($answer[0]) {
                                                            $counter = $counter + 1;
                                                        }
                                                    }

                                                    if($counter > 1)
                                                    {
                                                        $multi = true;
                                                    } else {
                                                        $multi = false;
                                                    }


?>

<div class="uk-padding">

<p class="uk-h4 uk-margin-remove-bottom"><b>Результат</b></p>
                <ul class="uk-comment-meta uk-subnav uk-subnav-divider uk-margin-remove-top tags-margin">
                    <li>
                        <?

                            foreach($tags as $tag) {
                                echo '<a><span class="uk-label uk-margin-small-right">'.$tag.'</span></a>';
                            }

                        ?>
                    </li>
                </ul> 

<p class="uk-h4 uk-margin-small-top"><?=$data["body"]?></p>

<p class="uk-text-meta uk-margin-small-top"><cite>Зеленым цветом помечены правильные ответы. Красным цветом отмечены несовпадения.</cite></p>
 

<form action="test.php" method="post">

<input type="hidden" name="a" value="next">
<input type="hidden" name="id" value="<?=$this->taskid?>">

<table class="uk-table uk-table-justify uk-table-divider uk-margin-remove">
                                            <thead>
                                                <tr>
                                                    <th class="uk-table-shrink">Верно</th>
                                                    <th>Текст ответа</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?
                                                    

                                                    $answerList = "";

                                                    if(!$multi) {
                                                        $counter = 0;
                                                    } else {
                                                        $counter = 1;
                                                    }


                                                    foreach (unserialize($data["answers"]) as $answer) {
                                                        if(!$multi) {
                                                            $ph = "";
                                                            $pc = "";
                                                            if(isset($_GET["answs"])) {
                                                                if(unserialize($_GET["answs"])[$counter] == 1) {
                                                                    $ph = "checked";
                                                                }
                                                            }
                                                            if(isset($_GET["res"])) {
                                                                if(unserialize($_GET["res"])[$counter] == 1) {
                                                                    $pc = "text-success";
                                                                }
                                                                if(unserialize($_GET["res"])[$counter] > 1) {
                                                                    $pc = "text-danger";
                                                                }
                                                            }
                                                            $answerList = $answerList.'<tr><td><label><input '.$ph.' class="uk-radio '.$pc.' uk-form-success uk-form-large test-chb" type="radio" name="ch0" value="'.$counter.'" type="checkbox"></label></td><td><p class="'.$pc.'">'.$answer[1].'</p></td></tr>';
                                                        } else {
                                                            $ph = "";
                                                            $pc = "";
                                                            if(isset($_GET["answs"])) {
                                                                if(unserialize($_GET["answs"])[$counter-1] == 1) {
                                                                    $ph = "checked";
                                                                }
                                                            }
                                                            if(isset($_GET["res"])) {
                                                                if(unserialize($_GET["res"])[$counter-1] == 1) {
                                                                    $pc = "text-success";
                                                                }
                                                                if(unserialize($_GET["res"])[$counter-1] > 1) {
                                                                    $pc = "text-danger";
                                                                }
                                                            }
                                                            $answerList = $answerList.'<tr><td><label><input '.$ph.' class="uk-checkbox  uk-form-success uk-form-large test-chb" name="ch'.$counter.'" value="yes" type="checkbox"></label></td><td><p class="'.$pc.'">'.$answer[1].'</p></td></tr>';
                                                        }
                                                        $counter++;
                                                    }

                                                    echo $answerList;

                                                ?>




                                                


                                            </tbody>
                                        </table>

                                        <div class="uk-margin-small2-top">
                                            <button type="submit" class="uk-button uk-width-1-1 uk-width-auto@s  uk-button-primary tm-button-primary uk-button-large tm-button-large uk-margin-small-right uk-margin-small-bottom">Следующий вопрос</button>
                                            <a href="?" class="uk-button uk-width-1-1 uk-width-auto@s  uk-button-default tm-button-default uk-button-large tm-button-large uk-margin-small-bottom">Завершить</a>
                                            <a href="?a=task&id=<?=$this->taskid?>" class="uk-button uk-width-1-1 uk-width-auto@s  uk-align-right	 uk-button-primary tm-button-default uk-margin-small-bottom">Обсудить задание</a>

                                        </div>
                                       
</form>
</div>