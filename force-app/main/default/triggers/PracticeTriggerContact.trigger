trigger PracticeTriggerContact on Contact (before insert,before update) {
    switch on Trigger.OperationType{
        when BEFORE_INSERT{
            Map<String,Contact> emailsMap = new Map<String,Contact>();
            Map<String,Contact> phonesMap = new Map<String ,Contact>();
            for(Contact con : Trigger.new)
            {
                emailsMap.put(con.Email,con);
                phonesMap.put(con.Phone,con);
            }
            List<Contact> contactList =[SELECT Id ,Phone,Email FROM Contact WHERE Phone IN : phonesMap.keySet() OR Email IN : emailsMap.keySet()];
            String errorMessage = '';
            if(contactList.size()>0)
            {
                for(Contact con :contactList)
                {
                    if(con.Email != null)
                    {
                        if(emailsMap.get(con.Email)!= null)
                        {
                            errorMessage='email';
                        }
                        if(con.Phone != null)
                        {
                            if(phonesMap.get(con.Phone)!= null)
                            {
                                errorMessage = errorMessage+(errorMessage=='' ? 'phone' : 'and phone');
                            }
                        }
                    }
                    if(errorMessage != null)
                    {
                        Trigger.new[0].addError('Your Contact '+errorMessage+ ' already exists in system.');
                    }
                }
                
            }
        }
        when BEFORE_UPDATE{
             Map<String,Contact> emailsMap = new Map<String,Contact>();
            Map<String,Contact> phonesMap = new Map<String ,Contact>();
            for(Contact con : Trigger.new)
            {
                if(con.Email != Trigger.oldMap.get(con.Id).Email)
                {
                    emailsMap.put(con.Email,con);
                }
                if(con.Phone != Trigger.oldMap.get(con.Id).Phone)
                {
                     phonesMap.put(con.Phone,con);
                }
            }
             List<Contact> contactList =[SELECT Id ,Phone,Email FROM Contact WHERE Phone IN : phonesMap.keySet() OR Email IN : emailsMap.keySet()];
            String errorMessage = '';
                   if(contactList.size()>0)
            {
                for(Contact con :contactList)
                {
                    if(con.Email != null)
                    {
                        if(emailsMap.get(con.Email)!= null)
                        {
                            errorMessage='email';
                        }
                        if(con.Phone != null)
                        {
                            if(phonesMap.get(con.Phone)!= null)
                            {
                                errorMessage = errorMessage+(errorMessage=='' ? 'phone' : 'and phone');
                            }
                        }
                    }
                    if(errorMessage != null)
                    {
                        Trigger.new[0].addError('Your Contact '+errorMessage+ ' already exists in system.');
                    }
                }
                
            }
        }
    }
}