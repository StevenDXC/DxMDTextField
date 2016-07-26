//
//  MDTextField.swift
//  DxMDTextField
//
//  Created by dxc on 16/5/26.
//  Copyright © 2016年 dxc. All rights reserved.
//
import UIKit

protocol MDTextFieldDelegate {

   func textFieldShouldBeginEditing(textField:UITextField) -> Bool;
   func textFieldDidBeginEditing(textField:UITextField);
   func textFieldShouldEndEditing(textField:UITextField) -> Bool;
   func textFieldDidEndEditing(textField:UITextField);
   func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool;
   func textFieldShouldClear(textField:UITextField) -> Bool;
   func textFieldShouldReturn(textField:UITextField) -> Bool;
   func textFieldDidChange(textField:UITextField);
}

public class MDTextField: UIView,UITextFieldDelegate{

    var delegate : MDTextFieldDelegate?
    
    
    private let defaultLineWidth:CGFloat = 2.0;
    private let defaultMaxInputLength:Int = 100;
    
    private var mLineColor:UIColor!;                //underLine color
    private var mLineWidth:CGFloat!;                //underLine'width,default is 2 pt
    private var mPlaceHolderColor:UIColor!;
    private var mHighLightColor:UIColor!;           //highLightColor,when textfield is editing,underline's bacground color and maxLengthLabel's text color will be highlighted
    private var mMaxInputLength:Int!;               //can input count of characters
    private var mPlaceHolder:String!;
    private var isLifted = false;                   // whether placeholder is floating
    private var showInputLength = false;            // show or not show maxLengthLabel
    private var textField:UITextField!;
    private var lineView:UIView!;                   //under line view
    private var highLightLineView:UIView!;          //highLighted under line view
    private var placeHolderLabel:UILabel!;          //placeholder label.replace textfield's placeholder;
    private var errorMsgLabel:UILabel!;             //when input is invalid or not correct，this lebal will show the error message;
    private var maxLengthLabel:UILabel!;
    private var hasAdded = false;
    
    override init(frame: CGRect) {
        super.init(frame:frame);
        intViews();
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews();
        if !hasAdded {
            textField.frame = CGRectMake(0, 16, CGRectGetWidth(self.frame), 32);
            lineView.frame = CGRectMake(0, 48 - mLineWidth, self.frame.size.width, mLineWidth);
            highLightLineView.frame = CGRectMake(0, 48 - mLineWidth, 0, mLineWidth);
            if (isLifted) {
                placeHolderLabel.frame = CGRectMake(2, 0, CGRectGetWidth(self.frame) - 4, 16);
            } else {
                placeHolderLabel.frame = CGRectMake(2, 16, CGRectGetWidth(self.frame) - 4, 32);
            }
            errorMsgLabel.frame = CGRectMake(2, 49, CGRectGetWidth(self.frame) - 4, 15);
            maxLengthLabel.frame = CGRectMake(CGRectGetWidth(self.frame) - 60, 49, 60, 15);
            self.bringSubviewToFront(placeHolderLabel);
            hasAdded = true;
        }
    }
    
    private func intViews(){
    
        mLineColor = UIColor.lightGrayColor();
        mLineWidth = defaultLineWidth;
        mPlaceHolderColor = UIColor.grayColor();
        mHighLightColor = UIColor.blueColor();
        mMaxInputLength = defaultMaxInputLength;
        
        textField = UITextField.init();
        textField.delegate = self;
        textField.placeholder = nil;
        textField.addTarget(self, action:#selector(editingChanged(_:)), forControlEvents: UIControlEvents.EditingChanged);
        self.addSubview(textField);
        
        lineView = UIView.init();
        lineView.backgroundColor = mLineColor;
        self.addSubview(lineView)
        
        highLightLineView = UIView.init();
        highLightLineView.backgroundColor = mHighLightColor;
        self.addSubview(highLightLineView)
        
        placeHolderLabel = UILabel.init();
        placeHolderLabel.font = UIFont.systemFontOfSize(14);
        if (mPlaceHolderColor != nil) {
            placeHolderLabel.textColor = mPlaceHolderColor;
        } else {
            placeHolderLabel.textColor = UIColor.grayColor();
        }
        placeHolderLabel.alpha = 0.75;
        addSubview(placeHolderLabel)
        
        errorMsgLabel = UILabel.init(frame: CGRectZero);
        errorMsgLabel.textColor = UIColor.redColor();
        errorMsgLabel.hidden = true;
        errorMsgLabel.font = UIFont.systemFontOfSize(12);
        self.addSubview(errorMsgLabel);
        
        maxLengthLabel = UILabel.init(frame: CGRectZero);
        maxLengthLabel.textColor = highLightColor;
        maxLengthLabel.font = UIFont.systemFontOfSize(10);
        maxLengthLabel.textAlignment = NSTextAlignment.Right;
        maxLengthLabel.hidden = true;
        self.addSubview(maxLengthLabel);
        
    }
    
    func editingChanged(textField:UITextField){
        if showInputLength && mMaxInputLength > 1 {
            let text:String = textField.text!;
            let lang:String = (textField.textInputMode?.primaryLanguage)!;
            //handle chinese input prompts
            if lang == "zh-Hans" && textField.markedTextRange != nil {
                let position:Int = textField.offsetFromPosition(textField.markedTextRange!.start, toPosition: textField.markedTextRange!.end)
                if position > 0{
                    return;
                }
            }
            if text.characters.count > mMaxInputLength {
                textField.text = (text as NSString).substringToIndex(mMaxInputLength);
            }
            updateTextNumber();
        }
        delegate?.textFieldDidChange(textField);
    }
    
    //start editing,highlighted,and placeholder view floating
    private func didBeginChangeTextField(){
        
      if (!errorMsgLabel.hidden) {
        
         highLightLineView.frame = CGRectMake(0, highLightLineView.frame.origin.y, 0, highLightLineView.frame.size.height);
         highLightLineView.backgroundColor = mHighLightColor;
         errorMsgLabel.hidden = true;
      }
    
     if (!isLifted) {
        UIView.animateWithDuration(0.25, animations: {
            
            self.placeHolderLabel.alpha = 1;
            self.placeHolderLabel.frame = CGRectMake(2, 0, self.placeHolderLabel.frame.size.width, 16);
            self.placeHolderLabel.font = UIFont.systemFontOfSize(10);
            self.highLightLineView.frame = CGRectMake(0,self.highLightLineView.frame.origin.y,self.lineView.frame.size.width,self.highLightLineView.frame.size.height);
            
            }, completion: { (finished:Bool) in
                self.isLifted = true;
        })
      } else{
        UIView.animateWithDuration(0.25, animations: {
            self.highLightLineView.frame = CGRectMake(0, self.highLightLineView.frame.origin.y, self.lineView.frame.size.width, self.highLightLineView.frame.size.height);
        });
      }
    }
    
    //end editing,to nornaml state
    private func didEndChangeTextField(){
        
        if (isLifted && !textField.hasText()) {
            UIView.animateWithDuration(0.25, animations:{
                self.placeHolderLabel.alpha = 0.6;
                self.placeHolderLabel.frame = CGRectMake(2, 16, CGRectGetWidth(self.frame) - 4, 32);
                self.placeHolderLabel.font = UIFont.systemFontOfSize(15);
                self.highLightLineView.frame = CGRectMake(0,  self.highLightLineView.frame.origin.y, 0,  self.highLightLineView.frame.size.height);
                
                },completion:{ (finished:Bool) in
                    if (finished) {
                       self.isLifted = false;
                   }
                });
            return;
        }
        
        UIView.animateWithDuration(0.25,animations:{
            
            self.highLightLineView.frame = CGRectMake(0, self.highLightLineView.frame.origin.y, 0, self.highLightLineView.frame.size.height);
        });


    }
    
    //upate display input characters'count
    private func updateTextNumber(){
        maxLengthLabel.text = String(format:"%d/%d",(textField.text?.characters.count)!,mMaxInputLength);
    }

    //set text
    private func updateText(text:String){
        textField.text = text;
        if !isLifted && text.characters.count > 0{
            placeHolderLabel.frame = CGRectMake(2, 0, placeHolderLabel.frame.size.width, 16);
            placeHolderLabel.font = UIFont.systemFontOfSize(10);
            isLifted = true;
        }
        
        if isLifted && text.characters.count == 0{
            placeHolderLabel.frame = CGRectMake(2, 16, CGRectGetWidth(self.frame) - 4, 32);
            placeHolderLabel.font = UIFont.systemFontOfSize(15);
            isLifted = false;
        }
        
        if (showInputLength) {
            updateTextNumber();
        }
    }
 
    //set error message,and display it
    public func setErrorMsg(errorMsg:String){
        if (errorMsg.isEmpty) {
            errorMsgLabel.text = nil;
            errorMsgLabel.hidden = true;
            highLightLineView.frame = CGRectMake(0, highLightLineView.frame.origin.y, 0, highLightLineView
                .frame.size.height);
            highLightLineView.backgroundColor = UIColor.redColor();
        } else {
            errorMsgLabel.text = errorMsg;
            errorMsgLabel.hidden = false;
            highLightLineView.frame = CGRectMake(0, highLightLineView.frame.origin.y, CGRectGetWidth(self.frame), highLightLineView.frame.size.height);
            highLightLineView.backgroundColor = UIColor.redColor();
        }
    }
    
    internal var textColor:UIColor?{
        set(color){
            textField.textColor = textColor;
        }
        get{
            return textField.textColor;
        }
    }
    
    internal var placeholderColor:UIColor?{
        set(color){
            mPlaceHolderColor = color;
            placeHolderLabel.textColor = color;
        }
        get{
            return mPlaceHolderColor;
        }
    }
    
    internal var secureTextEntry:Bool!{
        set(entry){
            textField.secureTextEntry = entry;
        }
        get{
            return textField.secureTextEntry;
        }
    }
    
    internal var keyboardType:UIKeyboardType{
        set(type){
            textField.keyboardType = type;
        }
        get{
            return textField.keyboardType;
        }
    }
    
    internal var font:UIFont?{
        set(newFont){
            textField.font = newFont;
        }
        get{
            return textField.font;
        }
    }

    //set text
    internal var text:String?{
        set(newText){
            updateText(newText!);
        }
        get{
            return textField.text;
        }
    }

    internal var placeholder:String{
        set(text){
            mPlaceHolder = text;
            placeHolderLabel.text = text;
        }
        get{
            return mPlaceHolder;
        }
    }
    
    internal var maxInputLength:Int?{
        set(length){
            mMaxInputLength = length;
            updateTextNumber();
        }
        get{
            return mMaxInputLength;
        }
    }
    
    internal var showMaxInputLength:Bool{
        set(show){
            showInputLength = show;
            if show {
                maxLengthLabel.text = String(format:"%d/%d",0,mMaxInputLength);
                maxLengthLabel.hidden = false;
                updateTextNumber();
            } else {
                maxLengthLabel.text = nil;
                maxLengthLabel.hidden = true;
            }
        }
        get{
          return showInputLength;
        }
    }
    
    internal var underLineWith:CGFloat{
        set(width){
            mLineWidth = width;
        }
        get{
            return mLineWidth;
        }
    }
    
   internal var underLineColor:UIColor?{
        set(color){
            mLineColor = color;
        }
        get{
            return mLineColor;
        }
    }
    
    internal var highLightColor:UIColor?{
        set(color){
            mHighLightColor = color;
            highLightLineView.backgroundColor = color;
        }
        get{
            return mHighLightColor;
        }
    }
    
    // MARK:textfield delegate
    public func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        didBeginChangeTextField();
        delegate?.textFieldShouldBeginEditing(textField);
        return true;
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        delegate?.textFieldDidBeginEditing(textField);
    }
    
    public func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        didEndChangeTextField();
        delegate?.textFieldShouldEndEditing(textField);
        return true;
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        delegate?.textFieldDidEndEditing(textField);
    }
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (!errorMsgLabel.hidden) {
            highLightLineView.frame = CGRectMake(0, highLightLineView.frame.origin.y, CGRectGetWidth(self.frame), highLightLineView.frame.size.height);
            highLightLineView.backgroundColor = mHighLightColor;
            errorMsgLabel.hidden = true;
        }
        
        delegate?.textField(textField, shouldChangeCharactersInRange: range, replacementString: string);
        return true;
    }
    
    
    public func textFieldShouldClear(textField:UITextField ) -> Bool{
      delegate?.textFieldShouldClear(textField);
      return false;
    }
    
    public func textFieldShouldReturn(textField:UITextField) -> Bool
    {
       textField.resignFirstResponder();
       delegate?.textFieldShouldReturn(textField);
       return false;
    }
    
}
