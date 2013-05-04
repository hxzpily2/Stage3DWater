package com.bigspaceship.utils.out.adapters
{

    public interface IOutAdapter
    {

//        public function IOutAdapter();

        function output($prefix:String, $level:String, ... args) : void;

        function clear() : void;

    }
}
