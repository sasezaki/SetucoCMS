<?php
class Setuco_Form_Decorator_SuffixString extends Zend_Form_Decorator_Abstract
{
    /**
     * HTMLエスケープ処理をするかどうか
     *
     * @var bool
     */
    protected $_escape;

    /**
     * HTMLタグで囲まれる文字列
     *
     * @var string
     */
    protected $_value;

    /**
     * HTMLタグで囲まれる文字列を設定します。
     *
     * @param  string $value
     * @return Setuco_Form_Decorator_SuffixString
     */
    public function setValue($value)
    {
        $this->_value = (string) $value;
        return $this;
    }

    /**
     * Get HTML tag, if any, with which to surround description
     *
     * @return string
     */
    public function getValue()
    {
        if (null === $this->_value) {
            $value = $this->getOption('value');
            if (null !== $value) {
                $this->removeOption('value');
            } else {
                $value = null;
            }

            $this->setValue($value);
            return $value;
        }

        return $this->_value;
    }

    /**
     * Set whether or not to escape description
     *
     * @param  bool $flag
     * @return Zend_Form_Decorator_Description
     */
    public function setEscape($flag)
    {
        $this->_escape = (bool) $flag;
        return $this;
    }

    /**
     * Get escape flag
     *
     * @return true
     */
    public function getEscape()
    {
        if (null === $this->_escape) {
            if (null !== ($escape = $this->getOption('escape'))) {
                $this->setEscape($escape);
                $this->removeOption('escape');
            } else {
                $this->setEscape(true);
            }
        }

        return $this->_escape;
    }

    /**
     * Render a suffix string
     *
     * @param  string $content
     * @return string
     */
    public function render($content)
    {
        $element = $this->getElement();
        $view    = $element->getView();
        if (null === $view) {
            return $content;
        }

        $value = $element->getValue();
        $value = trim($value);

        if (!empty($value) && (null !== ($translator = $element->getTranslator()))) {
            $value = $translator->translate($value);
        }

        if (empty($value)) {
            return $content;
        }

        $separator = $this->getSeparator();
        $placement = $this->getPlacement();
        $value     = $this->getValue();
        $escape    = $this->getEscape();

        $options   = $this->getOptions();

        if ($escape) {
            $value = $view->escape($value);
        }

        switch ($placement) {
            case self::PREPEND:
                return $value . $separator . $content;
            case self::APPEND:
            default:
                return $content . $separator . $value;
        }
    }
}