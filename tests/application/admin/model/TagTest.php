<?php

/**
 *
 * @author suzuki-mar
 */

//bootstarapを複数回読み込まないようにするため
if (!defined('BOOT_STRAP_FINSHED')) {
    require_once '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'bootstrap.php';
}



class Admin_Model_TagTest extends Setuco_Test_PHPUnit_DatabaseTestCase
{

    public function setup()
    {
        parent::setup();
        
        $this->_tag = new Admin_Model_Tag($this->getAdapter());
    }

    public function testFindTagIdsByKeyword_キーワードからタグIDを取得する()
    {
        $expected = $this->_createExpected->createTagIdsByKeyword('test');
        $this->assertEquals($expected, $this->_tag->findTagIdsByKeyword('test'));
    }

    public function testFindTagIdsByKeyword_キーワードからタグIDを取得する_複数キーワードに対応している()
    {
        $expected = $this->_createExpected->createTagIdsByKeyword('test setuco');
        $actual = $this->_tag->findTagIdsByKeyword('test setuco');

        sort($expected);
        sort($actual);

        $this->assertEquals($expected, $actual);
    }

}



